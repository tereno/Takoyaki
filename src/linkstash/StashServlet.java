package linkstash;

import java.io.IOException;
import java.util.logging.Logger;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class StashServlet extends HttpServlet {
    private static final Logger log = Logger.getLogger(StashServlet.class.getName());

    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        String link_name = req.getParameter("link_name");
        String link_href = req.getParameter("link_href");
        if (link_name == null) {
            link_name = "(No name)";
        }
        if (link_href == null) {
            link_href = "(No link)";
        }

        if (user != null) {
            Entity link = new Entity("Link");
            link.setProperty("name", link_name);
            link.setProperty("href", link_href);

            DatastoreService datastore =
                DatastoreServiceFactory.getDatastoreService();
            datastore.put(link);
            log.info("Link stashed by user " + user.getNickname() + ": " + link_name + " => " + link_href);
        }
        resp.sendRedirect("/linkstash.jsp");
    }
}
