package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.LabelRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MapRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.UpdateLabelInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.UpdateRoomInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Interior;
import at.porscheinformatik.desk.POIDeskAPI.Models.Label;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import at.porscheinformatik.desk.POIDeskAPI.Models.Room;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.CompletableFuture;

@Service
public class LabelService {
    @Autowired
    LabelRepo labelRepo;

    @Autowired
    MapRepo mapRepo;

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

    @Async
    public CompletableFuture<List<Label>> updateLabels(UUID mapId, List<UpdateLabelInput> labelInputs) throws Exception {

        Optional<Map> o_map = mapRepo.findById(mapId);
        if (o_map.isEmpty())
            throw new Exception("No map found with given ID");
        Map map = o_map.get();
        return updateLabels(map, labelInputs);
    }

    /**
     * <b>No side effects</b>
     * <br />
     * Calculates List of Labels with given input
     *
     * @param map The map the labels belong to.
     * @param labelInputs The new/updated label inputs.
     * @return The new/updated labels.
     *
     * @throws Exception if any given label ID does not exist
     */
    @Async
    public CompletableFuture<List<Label>> updateLabels(Map map, List<UpdateLabelInput> labelInputs) throws Exception {
        if (map.isPublished()) return null;

        List<Label> labels = labelRepo.findAllByMap(map);
        List<Label> finalLabels = new ArrayList<>();

        for (UpdateLabelInput labelInput : labelInputs) {
            if (labelInput.pk_labelId() == null) {
                System.out.println(labelInput.width());
                finalLabels.add(new Label(labelInput.text(), labelInput.x(), labelInput.y(), labelInput.width(), labelInput.height(), labelInput.rotation(), map, labelInput.localId()));
                continue;
            }
            Optional<Label> o_label = labels.stream().filter(room -> Objects.equals(room.getPk_labelId().toString(), labelInput.pk_labelId().toString())).findFirst();
            if (o_label.isEmpty()) {
                throw new Exception("Any given label ID does not exist");
            }
            Label c_label = o_label.get();
            c_label.updateProps(labelInput.text(), labelInput.x(), labelInput.y(), labelInput.width(), labelInput.height(), labelInput.rotation(), labelInput.localId());
            finalLabels.add(c_label);
        }

        labelRepo.saveAll(finalLabels);
        return CompletableFuture.completedFuture(finalLabels);
    }

    @Async
    public CompletableFuture<List<Label>> copyLabelsToMap(List<Label> labels, Map map) {
        List<Label> newLabels = labels.stream().map(l -> new Label(l.getText(), l.getX(), l.getY(), l.getWidth(), l.getHeight(), l.getRotation(), map, l.getLocalId())).toList();
        labelRepo.saveAll(newLabels);
        return CompletableFuture.completedFuture(newLabels);
    }
}
