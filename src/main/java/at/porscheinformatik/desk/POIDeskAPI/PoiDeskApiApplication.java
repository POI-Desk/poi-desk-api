package at.porscheinformatik.desk.POIDeskAPI;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;

@SpringBootApplication
@EnableAsync

public class PoiDeskApiApplication {

	public static void main(String[] args) {
		SpringApplication.run(PoiDeskApiApplication.class, args);
	}


	@Bean
	public Executor taskExecutor() {
		ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
		executor.setCorePoolSize(1024);
		executor.setMaxPoolSize(1024);
		executor.setQueueCapacity(2000);
		executor.setThreadNamePrefix("POI_Desk_API-");
		executor.initialize();
		return executor;
	}
}
