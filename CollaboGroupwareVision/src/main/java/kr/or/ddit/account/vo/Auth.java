package kr.or.ddit.account.vo;

import java.io.Serializable;

import lombok.Data;

@Data
public class Auth implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String empNo;
	private String auth;
}
