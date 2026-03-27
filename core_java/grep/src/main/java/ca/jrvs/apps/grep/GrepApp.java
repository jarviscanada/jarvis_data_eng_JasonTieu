    package ca.jrvs.apps.grep;

    import java.util.List;
    import java.io.BufferedReader;
    import java.io.BufferedWriter;
    import java.io.File;
    import java.io.FileReader;
    import java.io.FileWriter;
    import java.io.IOException;
    import java.util.ArrayList;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;

    public class GrepApp implements JavaGrep {

        private String rootPath;
        private String regex;
        private String outFile;
        private List<String> matchedLines;
        private List<String> files;
        private Logger logger = LoggerFactory.getLogger(GrepApp.class);

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

            logger.info("Files found: " + files.size());

            for (String file : files) {
                logger.info("Processing file: " + file);

                List<String> lines = readLines(file);
                logger.info("Lines read: " + lines.size());

                for (String line : lines) {
                    if (containsPattern(line)) {
                        matchedLines.add(line);
                    }
                }
            }

            logger.info("Matched lines: " + matchedLines.size());

            writeToFile(matchedLines);
        }

        @Override
        public List<String> listFiles(String rootDir) {
            File root = new File(rootDir);

            if (root.isFile()) {
                files.add(root.getAbsolutePath());
            } else if (root.isDirectory()) {
                File[] fileList = root.listFiles();
                if (fileList != null) {
                    for (File file : fileList) {
                        listFiles(file.getAbsolutePath());
                    }
                }
            }

            return files;
        }

        @Override
        public List<String> readLines(String file) {
            List<String> lines = new ArrayList<>();

            try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    lines.add(line);
                }
            } catch (IOException e) {
                logger.error("Error reading file: " + file, e);
            }

            return lines;
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
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(outFile))) {
                for (String line : lines) {
                    writer.write(line);
                    writer.newLine();
                }
            } catch (IOException e) {
                logger.error("Error writing to file: " + outFile, e);
            }
        }

        public static void main(String[] args) {
            
            if (args.length != 3) {
                System.out.println("Usage: java Main regex rootPath outFile");
                System.exit(1);
            }

            GrepApp grep = new GrepApp();
            grep.setRegex(args[0]);
            grep.setRootPath(args[1]);
            grep.setOutFile(args[2]);

            grep.process();
        }
    }
