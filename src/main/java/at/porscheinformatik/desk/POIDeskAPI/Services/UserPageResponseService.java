package at.porscheinformatik.desk.POIDeskAPI.Services;

import lombok.Getter;

import java.util.List;

@Getter
public class UserPageResponseService<T> {

        private List<T> content;
        private boolean hasNextPage;

        public UserPageResponseService(List<T> content, boolean hasNextPage) {
            this.content = content;
            this.hasNextPage = hasNextPage;
        }
}
