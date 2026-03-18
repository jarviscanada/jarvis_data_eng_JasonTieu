package ca.jrvs.apps.practice;

import java.util.regex.Pattern;
import java.util.regex.Matcher;


public interface RegexExc {
    /**
     * return true if filename extension is .jpg or jpeg (case insensitive)
     * @param filename
     * @return
     */
    public boolean matchJpeg(String filename);

    /**
     * return true if ip is valid ipv4 address
     * @param ip
     * @return
     */

    public boolean isIPv4(String ip);

    /**
     * return true if line is empty (e.g. "", " ", "\t")
     * @param line
     * @return
     */

    public boolean isEmptyLine(String line);

}