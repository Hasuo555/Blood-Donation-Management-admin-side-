package com.amyanhlu.admin.security;

import com.amyanhlu.admin.entity.Account;
import com.amyanhlu.admin.entity.Admin;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

/**
 * Custom UserDetails implementation wrapping the Account + Admin entities.
 * Exposes admin name and account ID for use in controllers and JSP views.
 */
public class AdminUserDetails implements UserDetails {

    private final Account account;
    private final Admin admin;

    public AdminUserDetails(Account account, Admin admin) {
        this.account = account;
        this.admin = admin;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority("ROLE_ADMIN"));
    }

    @Override
    public String getPassword() {
        return account.getPasswordHash();
    }

    @Override
    public String getUsername() {
        // Use email as the principal identifier
        return account.getEmail();
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return account.getStatus() != com.amyanhlu.admin.enums.AccountStatus.SUSPENDED;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return account.getStatus() == com.amyanhlu.admin.enums.AccountStatus.ACTIVE;
    }

    // --- Custom accessors ---

    public Long getAccountId() {
        return account.getId();
    }

    public String getAdminName() {
        return admin != null ? admin.getName() : account.getEmail();
    }

    public Long getAdminId() {
        return admin != null ? admin.getId() : null;
    }

    public Account getAccount() {
        return account;
    }
}
