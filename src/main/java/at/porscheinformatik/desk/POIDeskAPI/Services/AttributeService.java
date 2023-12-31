package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.AttributeRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Attribute;
import at.porscheinformatik.desk.POIDeskAPI.Models.Desk;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.CompletableFuture;

@Service
public class AttributeService {
    @Autowired
    AttributeRepo attributeRepo;

    @Async
    public CompletableFuture<List<Attribute>> deleteAttributes(List<Desk> desks) {
        Iterable<Attribute> i_attributes = attributeRepo.findAll();

        for (Attribute attribute:
             i_attributes) {
            attribute.setDesks(attribute.getDesks().stream().filter(desk -> !desks.contains(desk)).toList());
        }

        attributeRepo.saveAll(i_attributes);
        return CompletableFuture.completedFuture((List<Attribute>)i_attributes);
    }
}
