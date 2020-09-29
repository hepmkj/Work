package com.manoj;

import java.net.InetAddress;
import java.util.Enumeration;
import java.util.concurrent.TimeUnit;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

/*
Interceptor class which injects custom logging for each rest endpoint
 */
@Component
public class LoggerInterceptor extends HandlerInterceptorAdapter {

  private static final Logger logger = LoggerFactory.getLogger(LoggerInterceptor.class);

  private long startTime;
  private long endTime;

  @Override
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
    startTime = System.nanoTime();
    return true;
  }

  @Override
  public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
      ModelAndView modelAndView) throws Exception {
    endTime = System.nanoTime();
    super.postHandle(request, response, handler, modelAndView);
  }

  @Override
  public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
      throws Exception {
    super.afterCompletion(request, response, handler, ex);

    //Request
    String url = request.getRequestURL().toString();
    String uri = request.getRequestURI();
    String verb = request.getMethod();
    String token = request.getHeader("Authorization Bearer ");
    String remoteUser = request.getRemoteUser();
    String remoteAddr = getRemoteAddr(request);

    //Response
    long responseTime = TimeUnit.NANOSECONDS.toMillis(endTime - startTime);
    int responseStatus = response.getStatus();
    String executionHost = InetAddress.getLocalHost().getHostName();
    String parameters = getParameters(request);

    logger.info( "url: {}, uri: {}, verb: {}, token: {}, remoteUser: {}, "
            + "remoteAddr: {}, responseTime: {} ms, responseStatus: {}, "
            + "executionHost: {}, parameters from headers: {} ",
        url, uri, verb, token, remoteUser, remoteAddr, responseTime, responseStatus, executionHost, parameters);
  }

  private String getRemoteAddr(final HttpServletRequest request) {
    final String ipFromHeader = request.getHeader("X-FORWARDED-FOR");
    if (ipFromHeader != null && ipFromHeader.length() > 0) {
      logger.debug("ip from proxy - X-FORWARDED-FOR : " + ipFromHeader);
      return ipFromHeader;
    }
    return request.getRemoteAddr();
  }

  private String getParameters(HttpServletRequest request) {
    StringBuffer posted = new StringBuffer();
    Enumeration<?> e = request.getParameterNames();
    if (e != null) {
      posted.append("?");
    }
    while (e.hasMoreElements()) {
      if (posted.length() > 1) {
        posted.append("&");
      }
      String curr = (String) e.nextElement();
      posted.append(curr + "=");

      /*
      if (curr.contains("password")
          || curr.contains("pass")
          || curr.contains("pwd")) {
        posted.append("*****");
      } else {
        posted.append(request.getParameter(curr));
      }
       */
    }
    String ip = request.getHeader("X-FORWARDED-FOR");
    String ipAddr = (ip == null) ? getRemoteAddr(request) : ip;
    if (ipAddr != null && !ipAddr.equals("")) {
      posted.append("&_psip=" + ipAddr);
    }
    return posted.toString();
  }
}
