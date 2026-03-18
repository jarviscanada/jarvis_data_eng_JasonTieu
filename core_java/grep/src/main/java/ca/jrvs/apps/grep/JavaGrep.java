package ca.jrvs.apps.grep;

import java.io.IOException;
import java.util.List;

public interface JavaGrep {

    void process() throws IOException;
    
    List<String> listFiles(String rootDir);

    List<String> readLines(String file);

    boolean containsPattern(String line);

    void writeToFile(List<String> lines) throws IOException;

    String getRootPath();

    void setRootPath(String rootPath);

    String getRegex();

    void setRegex(String regex);

    String getOutFile();

    void setOutFile(String outFile);
}
