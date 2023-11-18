package at.porscheinformatik.desk.POIDeskAPI.Services;

import java.util.List;

public class UserPageResponse<T> {

        private List<T> content;
        private boolean hasNextPage;

        public UserPageResponse(List<T> content, boolean hasNextPage) {
            this.content = content;
            this.hasNextPage = hasNextPage;
        }
}
