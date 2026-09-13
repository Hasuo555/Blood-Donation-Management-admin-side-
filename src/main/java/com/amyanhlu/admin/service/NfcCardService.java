package com.amyanhlu.admin.service;

import com.amyanhlu.admin.dao.AuditLogDAO;
import com.amyanhlu.admin.entity.Account;
import com.amyanhlu.admin.entity.NfcCard;
import com.amyanhlu.admin.enums.NfcCardStatus;
import com.amyanhlu.admin.repository.NfcCardRepository;
import com.amyanhlu.admin.util.HttpRequestUtils;
import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class NfcCardService {

    private static final Logger log = LoggerFactory.getLogger(NfcCardService.class);

    private final NfcCardRepository nfcCardRepository;
    private final AuditLogDAO auditLogDAO;

    public NfcCardService(NfcCardRepository nfcCardRepository, AuditLogDAO auditLogDAO) {
        this.nfcCardRepository = nfcCardRepository;
        this.auditLogDAO = auditLogDAO;
    }

    @Transactional(readOnly = true)
    public List<NfcCard> findByDonorId(Long donorId) {
        return nfcCardRepository.findByDonorIdOrderByIssuedAtDesc(donorId);
    }

    @Transactional
    public void updateStatus(Long donorId, Long cardId, NfcCardStatus newStatus,
                             Account adminAccount, HttpServletRequest request) {
        NfcCard card = nfcCardRepository.findByIdAndDonorId(cardId, donorId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "NFC card not found for this donor: " + cardId));

        NfcCardStatus oldStatus = card.getStatus();
        card.setStatus(newStatus);
        nfcCardRepository.save(card);

        if (adminAccount != null) {
            String oldValue = AuditLogDAO.jsonObject("status", String.valueOf(oldStatus));
            String newValue = AuditLogDAO.jsonObject("status", String.valueOf(newStatus),
                    "card_uid", card.getCardUid());
            auditLogDAO.insert(adminAccount.getId(), "UPDATE_NFC_STATUS", "nfc_cards",
                    card.getId(), oldValue, newValue, HttpRequestUtils.clientIp(request));
        }
        log.info("NFC card {} status {} → {}", cardId, oldStatus, newStatus);
    }

}
