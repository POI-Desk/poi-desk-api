package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.UpdateLabelInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Label;
import at.porscheinformatik.desk.POIDeskAPI.Services.LabelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutionException;

@Controller
public class LabelController {
    @Autowired
    LabelService labelService;

    @MutationMapping
    List<Label> updateLabelsOnMap(@Argument UUID mapId, @Argument List<UpdateLabelInput> labelInputs) throws Exception {
        return labelService.updateLabels(mapId, labelInputs).get();
    }

    @MutationMapping
    List<Label> deleteLabels(@Argument List<UUID> labelIds) throws ExecutionException, InterruptedException {
        return labelService.deleteLabels(labelIds).get();
    }

}
