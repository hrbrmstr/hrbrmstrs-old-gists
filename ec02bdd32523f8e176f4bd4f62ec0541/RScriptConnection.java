
import org.rosuda.JRI.Rengine;

public class RScriptConnection {

  public Rengine getRScriptEngine() throws Exception {

    Rengine engine = null;
    try {
      engine = Rengine.getMainEngine();
      if (engine == null) engine = new Rengine(new String[] { "--vanilla" }, false, null);

      System.out.println("Connected to R");

    } catch(Exception ex) {
      System.out.println("Exeption while connecting to REngine " + ex.getMessage());
    }
    return engine;
  }

  public static void main(String[] args) {

    String libpath = System.getProperty("java.library.path");
    System.out.println("##############libpath=" + libpath);
    RScriptConnection rScriptConnection = new RScriptConnection();

    try {

      Rengine rEngine = rScriptConnection.getRScriptEngine();

      String Value1 = "\"Advisory\"";
      String Value2 = "\"Assurance\"";

      double svalue = rEngine.eval("(1+2)").asDouble();

      System.out.println("mvalue=" + svalue);

      System.out.println("method to be called in RScript is " + "cat(" + Value1 + "," + Value2 + ")");

      String value = rEngine.eval("cat(" + Value1 + "," + Value2 + ", file='/tmp/out.txt')").asString();

      System.out.println(value);

      rEngine.end();

    } catch(Exception e) {
      e.printStackTrace();
    }

  }
}