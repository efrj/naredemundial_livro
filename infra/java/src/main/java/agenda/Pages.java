package agenda;

import java.util.*;
import javax.servlet.http.*;
import javax.servlet.jsp.JspWriter;

/** Apresentação da agenda JSP, mantendo os campos e operações do livro. */
public final class Pages {
    private static final String[] LABELS = {"Nome", "Endereço", "DDD", "Fone", "Email", "Observações"};
    private static final int[] LENGTHS = {100,100,5,20,100,255};
    private static String h(String v) { return Main.escape(v); }
    private static String param(HttpServletRequest r, String name) { return Objects.toString(r.getParameter(name), ""); }
    private static void start(JspWriter out, String title, boolean logged) throws Exception {
        out.print("<!DOCTYPE html><html lang=\"pt-BR\"><head><meta charset=\"UTF-8\"><title>:: Agenda JSP ::</title></head><body bgcolor=\"#778899\"><table width=\"700\" border=\"0\" align=\"center\" bgcolor=\"white\"><tr><td>");
        if (logged) {
            out.print("<table width=\"100%\"><tr align=\"center\">");
            String[] pages = {"inserir","buscar","listar","index"};
            String[] labels = {"Inserir","Buscar","Listar","Sair"};
            for (int i=0;i<pages.length;i++) out.print("<td bgcolor=\"#EEE5DE\"><a href=\""+pages[i]+".jsp\">"+labels[i]+"</a></td>");
            out.print("</tr></table>");
        }
        out.print("<h2>"+h(title)+"</h2>");
    }
    private static void end(JspWriter out) throws Exception { out.print("</td></tr></table></body></html>"); }
    private static void form(JspWriter out, Map<String,String> row, boolean editing) throws Exception {
        out.print("<form method=\"post\" action=\""+(editing?"atualizar_agenda":"inserir_agenda")+".jsp\">");
        if (editing) out.print("<input type=\"hidden\" name=\"ID\" value=\""+h(row.get("ID"))+"\">");
        out.print("<table>");
        for (int i=0;i<Store.FIELDS.length;i++) {
            String key = Store.FIELDS[i];
            out.print("<tr><td align=\"right\"><label for=\""+key+"\">"+LABELS[i]+":</label></td><td>");
            if (key.equals("OBSERVACOES")) out.print("<textarea id=\""+key+"\" name=\""+key+"\" rows=\"5\" cols=\"40\" maxlength=\"255\">"+h(row.get(key))+"</textarea>");
            else out.print("<input id=\""+key+"\" name=\""+key+"\" maxlength=\""+LENGTHS[i]+"\" value=\""+h(row.get(key))+"\""+(i==0?" required":"")+">");
            out.print("</td></tr>");
        }
        out.print("<tr><td></td><td><button>Gravar &gt;&gt;</button> <button type=\"reset\">Limpar</button></td></tr></table></form>");
    }
    public static void render(HttpServletRequest request, HttpServletResponse response, JspWriter out, String page) throws Exception {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        HttpSession session = request.getSession();
        if (page.equals("index")) {
            session.removeAttribute("USUARIO");
            start(out,"Bem-vindo. Por favor, informe seus dados",false);
            if (request.getParameter("erro") != null) out.print("<p>Login ou senha inválidos.</p>");
            out.print("<form method=\"post\" action=\"login.jsp\"><p><label>Login: <input name=\"LOGIN\" required></label></p><p><label>Senha: <input type=\"password\" name=\"SENHA\" required></label></p><button>Acessar &gt;&gt;</button></form>");
            end(out); return;
        }
        if (page.equals("login")) {
            if (param(request,"LOGIN").equals("agenda") && param(request,"SENHA").equals("agenda")) {
                request.changeSessionId(); session.setAttribute("USUARIO","agenda"); response.sendRedirect("listar.jsp");
            } else response.sendRedirect("index.jsp?erro=1");
            return;
        }
        if (session.getAttribute("USUARIO") == null) { response.sendRedirect("index.jsp"); return; }
        try {
            if (page.equals("inserir_agenda") || page.equals("atualizar_agenda")) {
                if (!request.getMethod().equals("POST")) { response.sendRedirect("listar.jsp"); return; }
                Map<String,String> values = new HashMap<>();
                for (String key: Store.FIELDS) values.put(key,param(request,key));
                values.put("ID",param(request,"ID"));
                Main.store.save(values,page.equals("atualizar_agenda")); response.sendRedirect("listar.jsp"); return;
            }
            if (page.equals("excluir") && request.getMethod().equals("POST")) {
                Main.store.delete(param(request,"ID")); response.sendRedirect("listar.jsp"); return;
            }
            switch (page) {
                case "listar": case "search":
                    List<Map<String,String>> rows = Main.store.list(page.equals("search")?param(request,"KEY"):"");
                    start(out,page.equals("search")?"Resultado da busca":"Nomes cadastrados na agenda",true);
                    out.print("<table width=\"100%\" cellpadding=\"5\"><tr bgcolor=\"#EEE5DE\"><th>Editar</th><th>Nome</th><th>Email</th><th>Fone</th><th>Excluir</th></tr>");
                    for (Map<String,String> row:rows) {
                        String id = row.get("ID");
                        out.print("<tr><td><a href=\"editar.jsp?ID="+id+"\">Editar</a></td><td><a href=\"detalhes.jsp?ID="+id+"\">"+h(row.get("NOME"))+"</a></td><td>"+h(row.get("EMAIL"))+"</td><td>("+h(row.get("DDD"))+") "+h(row.get("FONE"))+"</td><td><a href=\"excluir.jsp?ID="+id+"\">Excluir</a></td></tr>");
                    }
                    out.print("</table>"); if (rows.isEmpty()) out.print("<p>Nenhum registro encontrado.</p>"); break;
                case "buscar":
                    start(out,"Buscar na agenda",true);
                    out.print("<form method=\"get\" action=\"search.jsp\"><label>Nome, email ou fone: <input name=\"KEY\"></label> <button>Buscar &gt;&gt;</button></form>"); break;
                case "inserir": start(out,"Inserir nomes na agenda",true); form(out,Map.of(),false); break;
                case "editar": case "detalhes": case "excluir":
                    Map<String,String> row = Main.store.get(param(request,"ID"));
                    start(out,page.equals("editar")?"Editar cadastro":(page.equals("excluir")?"Excluir cadastro":"Detalhes do cadastro"),true);
                    if (page.equals("editar")) form(out,row,true);
                    else if (page.equals("excluir")) out.print("<p>Excluir "+h(row.get("NOME"))+"?</p><form method=\"post\" action=\"excluir.jsp\"><input type=\"hidden\" name=\"ID\" value=\""+h(row.get("ID"))+"\"><button>Confirmar exclusão</button></form>");
                    else for (Map.Entry<String,String> field:row.entrySet()) out.print("<p><b>"+h(field.getKey())+":</b> "+h(field.getValue()).replace("\n","<br>")+"</p>");
                    break;
                default: response.sendError(404); return;
            }
        } catch (IllegalArgumentException e) {
            response.setStatus(400); start(out,"Não foi possível concluir",true); out.print("<p>"+h(e.getMessage())+"</p>");
        }
        out.print("<p><a href=\"listar.jsp\">Voltar à agenda</a></p>"); end(out);
    }
}
