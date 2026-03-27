package ca.jrvs.apps.practice;

public class RegexExcImp implements RegexExc {
    @Override
    public boolean matchJpeg(String fileName) {
        return fileName.matches(".*\\.jpg$|.*\\.jpeg$");
    }

    @Override
    public boolean isIPv4(String ip) {
        return ip.matches("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\." +
                "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\." +
                "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\." +
                "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$");
    }

    @Override
    public boolean isEmptyLine(String line) {
        return line.matches("^\\s*$");
    }

}
