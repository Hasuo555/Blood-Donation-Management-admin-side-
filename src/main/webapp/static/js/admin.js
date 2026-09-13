/* ==========================================================
   AMyanHlu Admin — JavaScript
   Sidebar toggle + alert auto-dismiss + image previews
   ========================================================== */

/**
 * Render a selected image file into a preview element before upload.
 * The file remains in the original input and is submitted normally.
 */
function previewSelectedImage(input, previewId) {
    const container = input
        ? (input.closest('.image-upload-field, .article-cover-field') || input.closest('.article-dropzone'))
        : null;
    const preview = document.getElementById(previewId);
    if (!preview) {
        return;
    }

    const file = input && input.files ? input.files[0] : null;
    if (!file || !file.type || !file.type.startsWith('image/')) {
        preview.removeAttribute('src');
        preview.hidden = true;
        if (container) {
            container.classList.remove('has-image-preview');
        }
        return;
    }

    const reader = new FileReader();
    reader.onload = function (event) {
        preview.src = event.target.result;
        preview.hidden = false;
        if (container) {
            container.classList.add('has-image-preview');
        }
    };
    reader.onerror = function () {
        preview.removeAttribute('src');
        preview.hidden = true;
        if (container) {
            container.classList.remove('has-image-preview');
        }
    };
    reader.readAsDataURL(file);
}

window.previewSelectedImage = previewSelectedImage;

document.addEventListener('DOMContentLoaded', function () {

    // --- Image file previews ---
    document.querySelectorAll('[data-image-preview-target]').forEach(function (input) {
        input.addEventListener('change', function () {
            previewSelectedImage(input, input.dataset.imagePreviewTarget);
        });
    });

    document.querySelectorAll('[data-image-preview-clear]').forEach(function (button) {
        button.addEventListener('click', function () {
            const input = document.getElementById(button.dataset.imagePreviewClear);
            if (!input) return;
            input.value = '';
            previewSelectedImage(input, input.dataset.imagePreviewTarget);
        });
    });

    // --- Sidebar toggle (responsive) ---
    const toggle = document.getElementById('sidebarToggle');
    const sidebar = document.getElementById('sidebar');
    if (toggle && sidebar) {
        toggle.addEventListener('click', function () {
            sidebar.classList.toggle('open');
        });
        // Close sidebar when clicking outside on mobile
        document.addEventListener('click', function (e) {
            if (sidebar.classList.contains('open') &&
                !sidebar.contains(e.target) &&
                !toggle.contains(e.target)) {
                sidebar.classList.remove('open');
            }
        });
    }

    // --- Auto-dismiss alerts after 6 seconds ---
    const alerts = document.querySelectorAll('.alert-success');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            alert.style.transition = 'opacity 300ms ease';
            alert.style.opacity = '0';
            setTimeout(function () { alert.remove(); }, 300);
        }, 6000);
    });

});
