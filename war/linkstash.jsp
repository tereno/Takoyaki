<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.lang.Iterable" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>

<html>
    <head>
        <link type="text/css" rel="stylesheet" href="/stylesheets/style.css" />
    </head>
    <body>

<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
%>
<p>Hello, <%= user.getNickname() %>! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
<%
    } else {
%>
<p>Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to include your name with greetings you post.</p>
<%
    }
%>
<%

    if (user != null) {
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.
    Query query = new Query("Link", KeyFactory.createKey("User", user.getUserId()));
    Iterable<Entity> links = datastore.prepare(query).asIterable();
%>
        <p>Links</p>
        <table>
        <%
        for (Entity link : links) {
        %>
            <tr>
                <td><a href="<%= link.getProperty("href") %>"><%= link.getProperty("name") %></a></td>
            </tr>
        <%
        }
        %>
        </table>
<%
    }
%>
        <form action="/stash" method="POST">
            <table>
                <tr><td>Name</td></tr>
                <tr><td><input type="text" name="link_name" /></td></tr>
                <tr><td>Link</td></tr>
                <tr><td><input type="text" name="link_href" /></td></tr>
            </table>
            <input type="submit" value="Stash link" />
        </form>
    </body>
</html>
