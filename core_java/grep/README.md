# Introduction
This application is a Java-based implementation of a simplified grep tool that searches for lines matching a given regular expression within files under a specified directory. The app recursively scans files, reads their contents, filters matching lines, and writes results to an output file. It is built using core Java, file I/O, and regular expressions, with logging supported by SLF4J. The project is managed with Maven and packaged using the Shade plugin to create an executable JAR.

# Quick Start
Package the application:

```bash 
mvn clean package
```

Run the application:
```bash
java -cp target/grep-1.0-SNAPSHOT.jar ca.jrvs.apps.grep.GrepApp "regex" "rootPath" "outFile"
```

Example:
```bash
java -cp target/grep-1.0-SNAPSHOT.jar ca.jrvs.apps.grep.GrepApp ".*Romeo.*Juliet.*" ./data ./out/grep.txt
```

# Implemenation
## Pseudocode
```
process:
    initialize empty list for files
    initialize empty list for matchedLines

    list all files under rootPath recursively

    for each file in files:
        read all lines from file

        for each line:
            if line matches regex:
                add line to matchedLines

    write matchedLines to output file
```

## Performance Issue
The application loads all file paths and matched lines into memory, which can cause high memory usage when processing large datasets. This may lead to performance degradation or `OutOfMemoryError`.

One way to mitigate this is by increasing the JVM heap size using JVM options such as `-Xmx`. However, a better long-term solution is to refactor the application to use streaming (e.g., processing files line-by-line and writing results incrementally) to reduce memory consumption and improve scalability. 

```bash
java -Xms256m -Xmx1024m -cp target/grep-1.0-SNAPSHOT.jar ca.jrvs.apps.grep.GrepApp "regex" "./data" "./out/output.txt"
```
Xms256m → initial heap size (256 MB)
Xmx1024m → maximum heap size (1024 mb)

# Test
Manual testing was done by preparing sample text files containing known patterns. Different regex patterns were tested to verify correct matching behavior. The output file was compared against expected results to ensure accuracy. Edge cases such as empty files, invalid paths, and no matches were also tested.

# Deployment
The application is containerized using Docker for easy distribution. First, the JAR file is built using Maven. Then, a Docker image is created by copying the JAR into a base Java image and setting the entry point to run the application. This allows the app to run consistently across different environments.
# Improvement
1. Refactor to use Java Stream API for better performance and readability.
2. Improve error handling and validation for input arguments and file operations.
