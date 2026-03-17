package ca.jrvs.apps.grep;

import java.util.List;
import java.io.IOException;
import java.util.ArrayList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Main implements JavaGrep {

    private String rootPath;
    private String regex;
    private String outFile;
    private List<String> matchedLines;
    private List<String> files;
    private Logger logger = LoggerFactory.getLogger(Main.class);

    @Override
    public void setRootPath(String rootPath) {
        this.rootPath = rootPath;
    }

    @Override
    public void setRegex(String regex) {
        this.regex = regex;
    }

    @Override
    public void setOutFile(String outFile) {
        this.outFile = outFile;
    }

    @Override
    public String getRootPath() {
        return this.rootPath;
    }

    @Override
    public String getRegex() {
        return this.regex;
    }

    @Override
    public String getOutFile() {
        return this.outFile;
    }

    @Override
    public void process() {
        logger.info("Starting process method");
        files = new ArrayList<>();
        matchedLines = new ArrayList<>();

        listFiles(rootPath);
        for (String file : files) {
            List<String> lines = readLines(file);
            for (String line : lines) {
                if (containsPattern(line)) {
                    matchedLines.add(line);
                }
            }
        }
        writeToFile(matchedLines);
        logger.info("Finished process method");

    }

    @Override
    public List<String> listFiles(String rootDir) {
        logger.info("Listing files in directory: " + rootDir);
        for (String file : files) {
            logger.info("Found file: " + file);
            files.add(file);
        }
        return null;
    }

    @Override
    public List<String> readLines(String file) {
        logger.info("Reading lines from file: " + file);
        for (String line : matchedLines) {
            logger.info("Read line: " + line);
            matchedLines.add(line);
        }
        return null;
    }

    @Override
    public boolean containsPattern(String line) {
        logger.info("Checking if line contains pattern: " + line);
        boolean contains = line.matches(".*" + regex + ".*");
        logger.info("Line contains pattern: " + contains);
        return contains;
    }

    @Override
    public void writeToFile(List<String> lines) {
        logger.info("Writing lines to file: " + outFile);
        for (String line : lines) {
            logger.info("Writing line: " + line);
        }
    }

    public static void main(String[] args) {
        if (args.length != 3) {
            System.out.println("Usage: java Main regex rootPath outFile");
            System.exit(1);
        }

        Main grep = new Main();
        grep.setRegex(args[0]);
        grep.setRootPath(args[1]);
        grep.setOutFile(args[2]);

        grep.process();
    }
}
