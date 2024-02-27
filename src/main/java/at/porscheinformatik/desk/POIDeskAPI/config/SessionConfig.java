package at.porscheinformatik.desk.POIDeskAPI.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.session.data.redis.config.annotation.web.http.EnableRedisHttpSession;
import org.springframework.session.web.http.CookieSerializer;
import org.springframework.session.web.http.DefaultCookieSerializer;

@Configuration
@EnableRedisHttpSession
public class SessionConfig {

    @Bean
    public CookieSerializer cookieSerializer() {
        DefaultCookieSerializer serializer = new DefaultCookieSerializer();
        serializer.setCookieName("SESSION"); // Set your custom cookie name
        serializer.setCookiePath("/"); // Set the cookie path as needed
        serializer.setDomainName("localhost"); // Set the domain if needed
        serializer.setUseSecureCookie(true); // Use secure cookie for HTTPS
        serializer.setUseHttpOnlyCookie(true); // Use HTTP-only cookie
        serializer.setSameSite("Lax"); // Set SameSite attribute (or "None" for cross-origin requests with credentials)

        // Additional customization options are available, check the DefaultCookieSerializer documentation

        return serializer;
    }
}