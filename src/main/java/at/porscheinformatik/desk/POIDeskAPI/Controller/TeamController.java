package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.TeamRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.UserRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Team;
import at.porscheinformatik.desk.POIDeskAPI.Models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.UUID;


@Controller
public class TeamController {
    @Autowired
    private TeamRepo teamRepo;

    @Autowired
    private UserRepo userRepo;

    @QueryMapping
    public List<Team> getAllTeams() { return (List<Team>)teamRepo.findAll(); }

    @MutationMapping
    public Team addTeam(@Argument String name, @Argument List<UUID> memberids, @Argument UUID leaderid) {
        Team team = new Team();
        team.setTeamname(name);
        memberids.forEach(System.out::println);
        memberids.stream().map(id -> userRepo.findById(id).get()).toList().forEach((user -> System.out.println(user.getUsername())));
        team.setTeammembers(memberids.stream().map(id -> userRepo.findById(id).get()).toList());
        team.setTeamleader(userRepo.findById(leaderid).get());
        teamRepo.save(team);
        return team;
    }

    @MutationMapping
    public Team deleteTeam(@Argument UUID teamid) {
        Team team = teamRepo.findById(teamid).get();
        teamRepo.delete(team);
        return team;
    }


    // 04ac4bcc-6ae0-4f81-8bea-2a0f4289e267
    // fb5b8832-bf20-4de8-aa37-e82579df8f2c
    // 5e928dcc-a8e8-4b61-8b83-f6d26e78ab6a

}
