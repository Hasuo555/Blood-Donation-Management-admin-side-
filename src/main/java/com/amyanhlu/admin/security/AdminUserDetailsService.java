package com.amyanhlu.admin.security;

import com.amyanhlu.admin.entity.Account;
import com.amyanhlu.admin.entity.Admin;
import com.amyanhlu.admin.enums.Role;
import com.amyanhlu.admin.repository.AccountRepository;
import com.amyanhlu.admin.repository.AdminRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Loads admin users from the accounts table.
 * Only accounts with role=ADMIN are permitted to authenticate.
 */
@Service
public class AdminUserDetailsService implements UserDetailsService {

    private final AccountRepository accountRepository;
    private final AdminRepository adminRepository;

    public AdminUserDetailsService(AccountRepository accountRepository,
            AdminRepository adminRepository) {
        this.accountRepository = accountRepository;
        this.adminRepository = adminRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // Try email first, then phone
        Account account = accountRepository.findByEmail(username)
                .or(() -> accountRepository.findByPhone(username))
                .orElseThrow(() -> new UsernameNotFoundException(
                        "No account found with email or phone: " + username));

        // Only ADMIN role accounts are allowed
        if (account.getRole() != Role.ADMIN) {
            throw new UsernameNotFoundException("Account is not an administrator");
        }

        // Load associated admin profile
        Admin admin = adminRepository.findByAccountId(account.getId()).orElse(null);

        return new AdminUserDetails(account, admin);
    }
}
