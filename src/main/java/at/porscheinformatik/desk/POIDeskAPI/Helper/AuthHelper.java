package at.porscheinformatik.desk.POIDeskAPI.Helper;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import jakarta.servlet.http.HttpServletRequest;

public class AuthHelper {

    public static String authenticate(HttpServletRequest request){
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

                return jwtToken;
            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }
        } else {
            // Handle case where Authorization header is missing or doesn't have the expected format
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
