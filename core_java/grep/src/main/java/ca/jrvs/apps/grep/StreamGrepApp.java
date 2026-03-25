package ca.jrvs.apps.grep;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class StreamGrepApp implements JavaGrep {
    // Instance variables
    private String rootPath;
    private String regex;
    private String outFile;
    private List<String> matchedLines;
    private List<String> files;
    private Logger logger = LoggerFactory.getLogger(StreamGrepApp.class);

    // Stream API and Lambda version
    public void process() {
        logger.info("Starting process method");

        files = listFiles(rootPath);
        logger.info("Files found: " + files.size());

        matchedLines = files.stream()
                .flatMap(file -> {
                    logger.info("Processing file: " + file);
                    List<String> lines = readLines(file);
                    logger.info("Lines read: " + lines.size());
                    return lines.stream();
                })
                .filter(line -> containsPattern(line))
                .collect(Collectors.toList());

        logger.info("Matched lines: " + matchedLines.size());
        try {
            writeToFile(matchedLines);
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    @Override
    public List<String> listFiles(String rootDir) {
       List<String> fileList = new ArrayList<>();
        java.io.File root = new java.io.File(rootDir);

        if (root.isFile()) {
            fileList.add(root.getAbsolutePath());
        } else if (root.isDirectory()) {
            java.io.File[] fileListArray = root.listFiles();
            if (fileListArray != null) {
                for (java.io.File file : fileListArray) {
                    fileList.addAll(listFiles(file.getAbsolutePath()));
                }
            }
        }

        return fileList;
    }

    @Override
    public List<String> readLines(String file) {    
        try (Stream<String> lines = Files.lines(Paths.get(file))) {
            return lines.collect(Collectors.toList());
        } catch (IOException e) {
            logger.error("Error reading file: " + file, e);
            return new ArrayList<>();
        }
    }

    @Override
    public boolean containsPattern(String line) {
        return line.matches(".*" + regex + ".*");
    }

    @Override
    public void writeToFile(List<String> lines) throws IOException {
        Path outputPath = Paths.get(outFile);
        
        try {
            // Create parent directories if they don't exist
            if (outputPath.getParent() != null) {
                Files.createDirectories(outputPath.getParent());
            }
            
            Files.write(outputPath, lines);
            logger.info("Successfully wrote " + lines.size() + " lines to " + outputPath.toAbsolutePath());
        } catch (IOException e) {
            logger.error("Error writing to file: " + outFile, e);
        }
    }

    public String getRootPath() {
        return rootPath;
    }

    public void setRootPath(String rootPath) {
        this.rootPath = rootPath;
    }

    public String getRegex() {
        return regex;
    }

    public void setRegex(String regex) {
        this.regex = regex;
    }

    public String getOutFile() {
        return outFile;
    }

    public void setOutFile(String outFile) {
        this.outFile = outFile;
    }

    public List<String> getMatchedLines() {
        return matchedLines;
    }


    public void setMatchedLines(List<String> matchedLines) {
        this.matchedLines = matchedLines;
    }

    public List<String> getFiles() {
        return files;
    }

    public void setFiles(List<String> files) {
        this.files = files;
    }

    public Logger getLogger() {
        return logger;
    }

    public void setLogger(Logger logger) {
        this.logger = logger;
    }

    public static void main(String[] args) {
        if (args.length != 3) {
            System.out.println("Usage: java GrepApp regex rootPath outFile");
            System.exit(1);
        }

        StreamGrepApp grep = new StreamGrepApp();
        grep.setRegex(args[0]);
        grep.setRootPath(args[1]);
        grep.setOutFile(args[2]);

        grep.process();
    }

}
