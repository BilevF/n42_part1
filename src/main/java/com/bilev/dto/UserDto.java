package com.bilev.dto;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

@Setter
@Getter
@EqualsAndHashCode(callSuper = true, of = {})
public class UserDto extends BasicUserDto {

    private Set<ContractDto> contracts = new HashSet<>();
}