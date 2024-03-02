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

    @QueryMapping
    public List<User> getMembersOfTeam(@Argument UUID teamid) {
        Team team = teamRepo.findById(teamid).get();
        return team.getTeammembers();
    }

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

    @MutationMapping
    public Team changeNameOfTeam(@Argument UUID teamid, @Argument String newName) {
        Team team = teamRepo.findById(teamid).get();
        team.setTeamname(newName);
        teamRepo.save(team);
        return team;
    }

    @MutationMapping
    public User removeMembersOfTeam(@Argument UUID teamid, @Argument List<UUID> userids) {
        Team team = teamRepo.findById(teamid).get();
        List<User> membersToRemove = userids.stream().map((i) -> userRepo.findById(i).get()).toList();
        List<User> members = team.getTeammembers();
        members.removeAll(membersToRemove);
        team.setTeammembers(members);
        teamRepo.save(team);
        return new User();
    }

    @MutationMapping
    public List<User> addMemberToTeam(@Argument UUID teamid, @Argument List<UUID> userids) {
        Team team = teamRepo.findById(teamid).get();
        List<User> newMembers = userids.stream()
                .map((u) -> userRepo.findById(u).get()).toList();
        List<User> members = team.getTeammembers();
        members.addAll(newMembers);
        team.setTeammembers(members);
        teamRepo.save(team);
        return newMembers;
    }

}
