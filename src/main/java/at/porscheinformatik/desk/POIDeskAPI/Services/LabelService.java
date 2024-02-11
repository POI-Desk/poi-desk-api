package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.LabelRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Interior;
import at.porscheinformatik.desk.POIDeskAPI.Models.Label;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

@Service
public class LabelService {
    @Autowired
    LabelRepo labelRepo;

    @Async
    public CompletableFuture<List<Label>> deleteLabels(List<UUID> labelIds){
        Iterable<Label> i_labels = labelRepo.findAllById(labelIds);
        List<Label> delLabel = new ArrayList<>();
        for (Label label :
                i_labels) {
            delLabel.add(label);
        }

        labelRepo.deleteAll(delLabel);
        return CompletableFuture.completedFuture(delLabel);
    }

    @Async
    public CompletableFuture<List<Label>> deleteLabels(Map map){
        List<UUID> labelIds = labelRepo.findAllByMap(map).stream().map(Label::getPk_labelId).toList();
        return deleteLabels(labelIds);
    }

}
