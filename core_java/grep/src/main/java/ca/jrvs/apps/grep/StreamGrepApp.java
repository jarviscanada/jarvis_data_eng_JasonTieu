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

public class StreamGrepApp extends GrepApp {
    private Logger logger = LoggerFactory.getLogger(StreamGrepApp.class);

    // Stream API and Lambda version
    @Override
    public void process() {
        logger.info("Starting process method");

        List<String> files = listFiles(getRootPath());
        logger.info("Files found: " + files.size());

         List<String> matchedLines = files.stream()
                        .flatMap(file -> {
                            logger.info("Processing file: " + file);
                            return readLines(file).stream();
                        })
                        .filter(line -> containsPattern(line))
                        .collect(Collectors.toList());

        logger.info("Matched lines: " + matchedLines.size());
        writeToFile(matchedLines);
        
    }

    @Override
    public List<String> listFiles(String rootDir) {
        if (rootDir == null) {
            logger.error("rootDir is null");
            return new ArrayList<>();
        }

       try (Stream<Path> paths = Files.walk(Paths.get(rootDir))) {
            return paths
                .filter(Files::isRegularFile)  // Only include regular files
                .map(Path::toAbsolutePath)
                .map(Path::toString)
                .collect(Collectors.toList());
        } catch (IOException e) {
            logger.error("Error walking directory: " + rootDir, e);
            return new ArrayList<>();
        }
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
    public void writeToFile(List<String> lines){
        String outFile = getOutFile();  // Use getter
        
        if (outFile == null) {
            logger.error("outFile is null");
            return;
        }
        
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
