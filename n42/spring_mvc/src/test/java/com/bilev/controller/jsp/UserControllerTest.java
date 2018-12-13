package com.bilev.controller.jsp;

import com.bilev.configuration.AppConfig;
import com.bilev.configuration.HibernateConfiguration;
import com.bilev.dao.api.UserDao;
import com.bilev.dto.BasicUserDto;
import com.bilev.dto.UserDto;
import com.bilev.exception.service.OperationFailed;
import com.bilev.model.User;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.jdbc.SqlGroup;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {AppConfig.class, HibernateConfiguration.class})
@WebAppConfiguration
@SqlGroup({
        @Sql(executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD, scripts = "classpath:04-insert-test-data.sql"),
        @Sql(executionPhase = Sql.ExecutionPhase.AFTER_TEST_METHOD, scripts = "classpath:05-clear.sql")
})
@Transactional
public class UserControllerTest {

    private MockMvc mockMvc;

    @Autowired
    private UserDao userDao;

    @Autowired
    private WebApplicationContext wac;

    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    @Qualifier("userDetailsServiceImpl")
    private UserDetailsService userDetailsService;


    private UsernamePasswordAuthenticationToken getPrincipal(String username) {

        UserDetails user = userDetailsService.loadUserByUsername(username);

        UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken(
                        user,
                        user.getPassword(),
                        user.getAuthorities());

        return authentication;
    }

    @Before
    public void setup() {
        mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();

    }

    @Test
    public void testNewUserPage() throws Exception {

        mockMvc.perform(get("/user/new").principal(getPrincipal("admin")))
                .andExpect(status().isOk())
                .andExpect(view().name("createUser"));
    }

    @Test
    public void testUserPage() throws Exception {
        User user = userDao.getByKey(1);

        mockMvc.perform(get("/user").param("userId", "1").principal(getPrincipal("admin")))
                .andExpect(status().isOk())
                .andExpect(model().attribute("client", hasProperty("email", is(user.getEmail()))))
                .andExpect(model().attribute("client", hasProperty("firstName", is(user.getFirstName()))))
                .andExpect(model().attribute("client", hasProperty("lastName", is(user.getLastName()))))
                .andExpect(model().attribute("client", hasProperty("birthDate", is(user.getBirthDate()))))
                .andExpect(view().name("clientAccount"));
    }

    @Test
    public void testUserPage_Exception() throws Exception {

        mockMvc.perform(get("/user").param("userId", "0").principal(getPrincipal("admin")))
                .andExpect(status().isOk())
                .andExpect(view().name("serverError"));
    }


    @Test
    public void testUserListPage() throws Exception {


        UserDto res = modelMapper.map(
                userDao.getByKey(1),
                UserDto.class);

        mockMvc.perform(get("/user/list").principal(getPrincipal("admin")))
                .andExpect(status().isOk())
                .andExpect(model().attribute("users", hasItem(res)))
                .andExpect(view().name("users"));
    }
}
