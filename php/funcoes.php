<?
/*
Função        : Fornecer variáveis, constantes e funções comuns
Desenvolvedor : Cerli Rocha
Data          : 30/05/2003
Atualização   : 30/06/2003
*/

define("BANCO", "AGENDA"); //Constante com o nome da base de dados
define("USUARIO", "agenda"); //Constante com o nome do usuário da base de dados
define("SENHA", "agenda"); //Constante com a senha do usuário da base de dados

$con = null;

function conecta($BANCO, $USER, $PASS)
{
    global $con;
    $con = odbc_connect($BANCO, $USER, $PASS);
}

if (!function_exists('odbc_connect')) {

    function odbc_connect($banco, $user, $pass)
    {
        return 1;
    }

    function _odbc_http_post($op, $params)
    {
        $body = "op=" . urlencode($op);
        foreach ($params as $k => $v) {
            $body .= "&" . urlencode($k) . "=" . urlencode($v);
        }
        $fp = @fsockopen("jsp", 8081, $errno, $errstr, 10);
        if (!$fp) {
            return false;
        }
        $req = "POST /agenda HTTP/1.0\r\n";
        $req .= "Host: jsp\r\n";
        $req .= "Content-Type: application/x-www-form-urlencoded; charset=UTF-8\r\n";
        $req .= "Content-Length: " . strlen($body) . "\r\n";
        $req .= "Connection: Close\r\n\r\n";
        $req .= $body;
        fwrite($fp, $req);
        $resp = "";
        while (!feof($fp)) {
            $resp .= fread($fp, 8192);
        }
        fclose($fp);
        $parts = explode("\r\n\r\n", $resp, 2);
        if (count($parts) < 2) return false;

        $parser = xml_parser_create("UTF-8");
        xml_parser_set_option($parser, XML_OPTION_CASE_FOLDING, 1);
        $vals = array();
        $idx = array();
        $ok = xml_parse_into_struct($parser, $parts[1], $vals, $idx);
        xml_parser_free($parser);
        if (!$ok) return false;

        $rows = array();
        $row = array();
        $inside = false;
        $success = false;
        foreach ($vals as $node) {
            $tag = $node['tag'];
            $type = $node['type'];
            $val = isset($node['value']) ? $node['value'] : '';

            if ($tag == 'OK' && $val == '1') {
                $success = true;
            }
            if ($tag == 'ROW' && $type == 'open') {
                $row = array();
                $inside = true;
            } elseif ($tag == 'ROW' && $type == 'close') {
                $rows[] = $row;
                $inside = false;
            } elseif ($inside && $type == 'complete') {
                $row[$tag] = $val;
            }
        }
        if (!$success) return false;
        return $rows;
    }

    function _odbc_parse_insert_params($sql)
    {
        $params = array(
            'NOME' => isset($_POST['NOME']) ? $_POST['NOME'] : '',
            'ENDERECO' => isset($_POST['ENDERECO']) ? $_POST['ENDERECO'] : '',
            'DDD' => isset($_POST['DDD']) ? $_POST['DDD'] : '',
            'FONE' => isset($_POST['FONE']) ? $_POST['FONE'] : '',
            'EMAIL' => isset($_POST['EMAIL']) ? $_POST['EMAIL'] : '',
            'OBSERVACOES' => isset($_POST['OBSERVACOES']) ? $_POST['OBSERVACOES'] : ''
        );

        $pos = strpos(strtoupper($sql), 'VALUES');
        if ($pos !== false) {
            $val_str = substr($sql, $pos);
            $fields = array('NOME', 'ENDERECO', 'DDD', 'FONE', 'EMAIL', 'OBSERVACOES');
            $i = 0;
            $offset = 0;
            while ($i < count($fields)) {
                $q1 = strpos($val_str, "'", $offset);
                if ($q1 === false) break;
                $q2 = strpos($val_str, "'", $q1 + 1);
                if ($q2 === false) break;
                $val = substr($val_str, $q1 + 1, $q2 - ($q1 + 1));
                $params[$fields[$i]] = $val;
                $offset = $q2 + 1;
                $i++;
            }
        }
        return $params;
    }

    function _odbc_parse_update_params($sql)
    {
        $fields = array('NOME', 'ENDERECO', 'DDD', 'FONE', 'EMAIL', 'OBSERVACOES');
        $params = array(
            'ID' => '',
            'NOME' => isset($_POST['NOME']) ? $_POST['NOME'] : '',
            'ENDERECO' => isset($_POST['ENDERECO']) ? $_POST['ENDERECO'] : '',
            'DDD' => isset($_POST['DDD']) ? $_POST['DDD'] : '',
            'FONE' => isset($_POST['FONE']) ? $_POST['FONE'] : '',
            'EMAIL' => isset($_POST['EMAIL']) ? $_POST['EMAIL'] : '',
            'OBSERVACOES' => isset($_POST['OBSERVACOES']) ? $_POST['OBSERVACOES'] : ''
        );

        $sql_upper = strtoupper($sql);
        $pos_id = strpos($sql_upper, 'WHERE ID');
        if ($pos_id !== false) {
            $eq = strpos($sql, '=', $pos_id);
            if ($eq !== false) {
                $params['ID'] = trim(substr($sql, $eq + 1));
            }
        }
        if (empty($params['ID']) && isset($_POST['ID'])) {
            $params['ID'] = $_POST['ID'];
        }

        foreach ($fields as $field) {
            $pos = strpos($sql_upper, $field);
            if ($pos !== false) {
                $q1 = strpos($sql, "'", $pos);
                if ($q1 !== false) {
                    $q2 = strpos($sql, "'", $q1 + 1);
                    if ($q2 !== false) {
                        $params[$field] = substr($sql, $q1 + 1, $q2 - ($q1 + 1));
                    }
                }
            }
        }
        return $params;
    }

    function odbc_exec($con, $sql)
    {
        $sql_upper = strtoupper(trim($sql));

        if (strpos($sql_upper, 'UPDATE') !== false) {
            $params = _odbc_parse_update_params($sql);
            $res = _odbc_http_post('update', $params);
            return ($res !== false);
        } elseif (strpos($sql_upper, 'DELETE') !== false) {
            $parts = explode('=', $sql);
            $id = trim($parts[count($parts) - 1]);
            $res = _odbc_http_post('delete', array('ID' => $id));
            return ($res !== false);
        } elseif (strpos($sql_upper, 'INSERT') !== false) {
            $params = _odbc_parse_insert_params($sql);
            $res = _odbc_http_post('insert', $params);
            return ($res !== false);
        } elseif (strpos($sql_upper, 'LIKE') !== false) {
            $pos1 = strpos($sql, "'%");
            if ($pos1 !== false) {
                $pos2 = strpos($sql, "%'", $pos1 + 2);
                $key = substr($sql, $pos1 + 2, $pos2 - ($pos1 + 2));
            } else {
                $key = '';
            }
            $rows = _odbc_http_post('list', array('KEY' => $key));
        } elseif (strpos($sql_upper, 'WHERE ID') !== false) {
            $parts = explode('=', $sql);
            $id = trim($parts[count($parts) - 1]);
            $rows = _odbc_http_post('get', array('ID' => $id));
        } elseif (strpos($sql_upper, 'SELECT') !== false) {
            $rows = _odbc_http_post('list', array());
        } else {
            return false;
        }

        if ($rows === false) return false;

        $res_obj = new stdClass();
        $res_obj->rows = $rows;
        $res_obj->cursor = 0;
        $res_obj->current = null;
        return $res_obj;
    }

    function odbc_fetch_row(&$result)
    {
        if (!is_object($result) || !isset($result->rows)) return false;
        if ($result->cursor < count($result->rows)) {
            $result->current = $result->rows[$result->cursor];
            $result->cursor++;
            return true;
        }
        return false;
    }

    function odbc_result($result, $field)
    {
        if (!is_object($result) || !isset($result->current)) return "";
        $row = $result->current;
        if (is_numeric($field)) {
            $map = array(1 => 'ID', 2 => 'NOME', 3 => 'ENDERECO', 4 => 'DDD', 5 => 'FONE', 6 => 'EMAIL', 7 => 'OBSERVACOES', 8 => 'DATA');
            if (isset($map[$field])) {
                $key = $map[$field];
            } else {
                return "";
            }
        } else {
            $key = strtoupper($field);
        }
        return isset($row[$key]) ? $row[$key] : "";
    }
}
?>