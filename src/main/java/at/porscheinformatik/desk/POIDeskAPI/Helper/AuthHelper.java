package at.porscheinformatik.desk.POIDeskAPI.Helper;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.AccountRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Account;
import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.auth.oauth2.GoogleRefreshTokenRequest;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.services.people.v1.PeopleService;
import com.google.api.services.people.v1.model.Person;
import com.google.auth.oauth2.GoogleCredentials;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.FileInputStream;

public class AuthHelper {
    public static String authenticate(HttpServletRequest request, AccountRepo accountRepo){
        String authorizationHeader = request.getHeader("Authorization");

        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer")) {
            String jwtToken = authorizationHeader.substring(7).strip(); // Remove "Bearer " prefix
            DecodedJWT jwt;
            try {
                Algorithm algorithm = Algorithm.HMAC256("lol");
                JWTVerifier verifier = JWT.require(algorithm)
                        .withIssuer("POIDesk")
                        .build();
                jwt = verifier.verify(jwtToken);


                Account user = accountRepo.findById(jwt.getClaim("sub").asString()).get();
                if (user == null) {
                    return null;
                }
                var credential = new GoogleCredential().setAccessToken(user.getAccess_token());
                Person me = null;
                while (me == null){
                    try{
                        PeopleService peopleService = new PeopleService.Builder(new NetHttpTransport(), new GsonFactory(), credential).build();
                        me = peopleService.people().get("people/me").setPersonFields("names,emailAddresses").execute();
                    }
                    catch (Exception e){
                        GoogleRefreshTokenRequest refreshTokenRequest = new GoogleRefreshTokenRequest(new NetHttpTransport(), new GsonFactory(), user.getRefresh_token(), "30449198569-8ti9l20a7quemfkp1phf27fhf546d469.apps.googleusercontent.com", "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");
                        var test = refreshTokenRequest.execute();
                        credential.setAccessToken(test.getAccessToken());
                        user.setAccess_token(credential.getAccessToken());
                        accountRepo.save(user);

                    }
                }
                return jwtToken;
            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }
        } else {
            return null;
        }

    }

    public static String getUsernameFromJWT(String jwtToken){
        DecodedJWT jwt;
        try {
            Algorithm algorithm = Algorithm.HMAC256("lol");
            JWTVerifier verifier = JWT.require(algorithm)
                    .withIssuer("POIDesk")
                    .build();
            jwt = verifier.verify(jwtToken);

            return jwt.getClaim("username").asString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String authWithJWT(String token){
        DecodedJWT jwt;
        try {
            Algorithm algorithm = Algorithm.HMAC256("lol");
            JWTVerifier verifier = JWT.require(algorithm)
                    .withIssuer("POIDesk")
                    .build();
            jwt = verifier.verify(token);

            return token;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
