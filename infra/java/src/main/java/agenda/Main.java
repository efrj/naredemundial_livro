package agenda;

import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.net.*;
import java.util.*;
import java.util.concurrent.Executors;
import com.sun.net.httpserver.*;
import org.apache.catalina.Context;
import org.apache.catalina.startup.Tomcat;
import org.apache.jasper.servlet.JasperInitializer;

public final class Main {
    public static Store store;
    public static void main(String[] args) throws Exception {
        Path database = Path.of(System.getenv().getOrDefault("AGENDA_DATABASE", "/database/agenda.mdb"));
        store = new Store(database);
        if (args.length > 0 && args[0].equals("--init")) { store.close(); return; }
        HttpServer api = HttpServer.create(new InetSocketAddress(8081), 32);
        api.createContext("/health", e -> {
            byte[] data = "ok\n".getBytes(StandardCharsets.UTF_8);
            e.sendResponseHeaders(200, data.length); e.getResponseBody().write(data); e.close();
        });
        api.createContext("/agenda", Main::handle);
        api.setExecutor(Executors.newFixedThreadPool(4));
        Tomcat tomcat = new Tomcat();
        tomcat.setBaseDir("/tmp/agenda-tomcat");
        tomcat.setPort(8080);
        tomcat.getConnector().setURIEncoding("UTF-8");
        Context context = tomcat.addWebapp("", System.getenv().getOrDefault("AGENDA_WEBROOT", "/opt/agenda/webapp"));
        context.setParentClassLoader(Main.class.getClassLoader());
        context.addServletContainerInitializer(new JasperInitializer(), null);
        context.addWelcomeFile("index.jsp");
        tomcat.start();
        api.start();
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            api.stop(1);
            try { tomcat.stop(); store.close(); } catch (Exception e) { e.printStackTrace(); }
        }));
        tomcat.getServer().await();
    }

    private static void handle(HttpExchange e) throws java.io.IOException {
        int status = 200;
        String xml;
        try {
            if (!e.getRequestMethod().equals("POST")) throw new IllegalArgumentException("Use POST.");
            byte[] body = e.getRequestBody().readNBytes(16385);
            if (body.length > 16384) throw new IllegalArgumentException("Requisição muito grande.");
            Map<String,String> p = new HashMap<>();
            for (String pair : new String(body, StandardCharsets.UTF_8).split("&")) {
                String[] kv = pair.split("=", 2);
                if (kv.length == 2) p.put(URLDecoder.decode(kv[0], StandardCharsets.UTF_8), URLDecoder.decode(kv[1], StandardCharsets.UTF_8));
            }
            List<Map<String,String>> rows = List.of();
            switch (p.getOrDefault("op", "")) {
                case "list": rows = store.list(p.getOrDefault("KEY", "")); break;
                case "get": rows = List.of(store.get(p.get("ID"))); break;
                case "insert": store.save(p, false); break;
                case "update": store.save(p, true); break;
                case "delete": store.delete(p.get("ID")); break;
                default: throw new IllegalArgumentException("Operação inválida.");
            }
            StringBuilder out = new StringBuilder("<result><ok>1</ok>");
            for (Map<String,String> row : rows) {
                out.append("<row>");
                row.forEach((k,v) -> out.append('<').append(k).append('>').append(escape(v)).append("</").append(k).append('>'));
                out.append("</row>");
            }
            xml = out.append("</result>").toString();
        } catch (IllegalArgumentException ex) {
            status = 400; xml = "<result><ok>0</ok><error>" + escape(ex.getMessage()) + "</error></result>";
        } catch (Exception ex) {
            ex.printStackTrace(); status = 500; xml = "<result><ok>0</ok><error>Falha no acesso ao banco.</error></result>";
        }
        byte[] data = ("<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + xml).getBytes(StandardCharsets.UTF_8);
        e.getResponseHeaders().set("Content-Type", "application/xml; charset=UTF-8");
        e.sendResponseHeaders(status, data.length);
        e.getResponseBody().write(data); e.close();
    }
    public static String escape(String value) {
        return Objects.toString(value, "").replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
}
