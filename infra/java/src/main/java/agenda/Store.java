package agenda;

import java.nio.file.*;
import java.nio.channels.*;
import java.sql.*;
import java.util.*;

/** Único proprietário do MDB. Todas as operações das três agendas passam aqui. */
public final class Store implements AutoCloseable {
    public static final String[] FIELDS = {"NOME", "ENDERECO", "DDD", "FONE", "EMAIL", "OBSERVACOES"};
    private static final int[] LENGTHS = {100, 100, 5, 20, 100, 255};
    private final Connection connection;
    private final FileChannel lockChannel;
    private final FileLock lock;

    public Store(Path path) throws Exception {
        path = path.toAbsolutePath();
        Files.createDirectories(path.getParent());
        lockChannel = FileChannel.open(path.resolveSibling("agenda.process.lock"), StandardOpenOption.CREATE, StandardOpenOption.WRITE);
        lock = lockChannel.tryLock();
        if (lock == null) throw new IllegalStateException("O banco já está aberto por outro processo.");
        boolean exists = Files.exists(path);
        Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");
        connection = DriverManager.getConnection("jdbc:ucanaccess://" + path + ";newDatabaseVersion=V2000;openExclusive=true");
        connection.setAutoCommit(true);
        if (!exists) {
            try (Statement s = connection.createStatement()) {
                s.executeUpdate("CREATE TABLE Agenda (ID COUNTER PRIMARY KEY, NOME VARCHAR(100), ENDERECO VARCHAR(100), DDD VARCHAR(5), FONE VARCHAR(20), EMAIL VARCHAR(100), OBSERVACOES VARCHAR(255), DATA DATETIME)");
            }
            System.out.println("Criado " + path + " (Access 2000 / Jet 4).");
        }
        try (Statement s = connection.createStatement(); ResultSet r = s.executeQuery("SELECT ID, NOME, ENDERECO, DDD, FONE, EMAIL, OBSERVACOES, DATA FROM Agenda WHERE 1=0")) {
            // Confere o esquema sem modificar um banco existente.
        }
    }

    public synchronized List<Map<String,String>> list(String key) throws SQLException {
        String sql = "SELECT ID, NOME, ENDERECO, DDD, FONE, EMAIL, OBSERVACOES, DATA FROM Agenda";
        if (key != null && !key.isEmpty()) sql += " WHERE NOME LIKE ? OR EMAIL LIKE ? OR FONE LIKE ?";
        sql += " ORDER BY NOME, ID";
        try (PreparedStatement p = connection.prepareStatement(sql)) {
            if (key != null && !key.isEmpty()) for (int i=1; i<=3; i++) p.setString(i, "%" + key + "%");
            try (ResultSet r = p.executeQuery()) { return rows(r); }
        }
    }

    public synchronized Map<String,String> get(String id) throws SQLException {
        try (PreparedStatement p = connection.prepareStatement("SELECT ID, NOME, ENDERECO, DDD, FONE, EMAIL, OBSERVACOES, DATA FROM Agenda WHERE ID=?")) {
            p.setInt(1, id(id));
            try (ResultSet r = p.executeQuery()) {
                List<Map<String,String>> rows = rows(r);
                if (rows.isEmpty()) throw new IllegalArgumentException("Registro não encontrado.");
                return rows.get(0);
            }
        }
    }

    public synchronized void save(Map<String,String> values, boolean update) throws SQLException {
        for (int i=0; i<FIELDS.length; i++) {
            String value = values.getOrDefault(FIELDS[i], "");
            if (value.length() > LENGTHS[i]) throw new IllegalArgumentException(FIELDS[i] + ": tamanho máximo " + LENGTHS[i] + ".");
        }
        if (values.getOrDefault("NOME", "").trim().isEmpty()) throw new IllegalArgumentException("Informe o nome.");
        String sql = update ? "UPDATE Agenda SET NOME=?, ENDERECO=?, DDD=?, FONE=?, EMAIL=?, OBSERVACOES=? WHERE ID=?" :
            "INSERT INTO Agenda (NOME, ENDERECO, DDD, FONE, EMAIL, OBSERVACOES) VALUES (?,?,?,?,?,?)";
        try (PreparedStatement p = connection.prepareStatement(sql)) {
            for (int i=0; i<FIELDS.length; i++) p.setString(i+1, values.getOrDefault(FIELDS[i], ""));
            if (update) p.setInt(7, id(values.get("ID")));
            if (p.executeUpdate() != 1) throw new IllegalArgumentException("Registro não encontrado.");
        }
    }

    public synchronized void delete(String id) throws SQLException {
        try (PreparedStatement p = connection.prepareStatement("DELETE FROM Agenda WHERE ID=?")) {
            p.setInt(1, id(id));
            if (p.executeUpdate() != 1) throw new IllegalArgumentException("Registro não encontrado.");
        }
    }

    private static int id(String value) {
        try { int id = Integer.parseInt(value); if (id > 0) return id; }
        catch (NumberFormatException ignored) { }
        throw new IllegalArgumentException("Código inválido.");
    }
    private static List<Map<String,String>> rows(ResultSet r) throws SQLException {
        List<Map<String,String>> rows = new ArrayList<>();
        while (r.next()) {
            Map<String,String> row = new LinkedHashMap<>();
            for (int i=1; i<=r.getMetaData().getColumnCount(); i++) row.put(r.getMetaData().getColumnLabel(i).toUpperCase(Locale.ROOT), Objects.toString(r.getString(i), ""));
            rows.add(row);
        }
        return rows;
    }
    public synchronized Connection getJspConnection() {
        return (Connection) java.lang.reflect.Proxy.newProxyInstance(
            Connection.class.getClassLoader(),
            new Class<?>[] { Connection.class },
            (proxy, method, args) -> {
                if ("close".equals(method.getName())) {
                    return null;
                }
                return method.invoke(connection, args);
            }
        );
    }
    public synchronized void close() throws Exception {
        try { connection.close(); } finally { lock.release(); lockChannel.close(); }
    }
}

