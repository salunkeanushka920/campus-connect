/**
 * Campus Connect - Front-end JavaScript Helpers
 */

document.addEventListener('DOMContentLoaded', function () {

    // 1. Dynamic Block -> Room Filter for Complaint Submission Form
    const blockSelect = document.getElementById('blockFilter');
    const locationSelect = document.getElementById('locationSelect');

    if (blockSelect && locationSelect) {
        blockSelect.addEventListener('change', function () {
            const selectedBlock = this.value;
            const options = locationSelect.querySelectorAll('option');

            options.forEach(opt => {
                if (!opt.value) {
                    opt.hidden = false; // "Select Room/Location" placeholder
                    return;
                }
                const optBlock = opt.getAttribute('data-block');
                if (!selectedBlock || selectedBlock === 'ALL' || optBlock === selectedBlock) {
                    opt.hidden = false;
                } else {
                    opt.hidden = true;
                }
            });

            // Reset location selection
            locationSelect.value = '';
        });
    }

    // 2. Client-side Form Validation for Registration
    const regForm = document.getElementById('registerForm');
    if (regForm) {
        regForm.addEventListener('submit', function (e) {
            const pwd = document.getElementById('regPassword');
            const cpwd = document.getElementById('regConfirmPassword');

            if (pwd && cpwd && pwd.value !== cpwd.value) {
                e.preventDefault();
                alert('Password and Confirm Password do not match!');
                cpwd.focus();
            }
        });
    }

    // 3. Quick Table Search Filter (Client-side instant filter)
    const tableSearch = document.getElementById('tableSearchInput');
    const targetTable = document.getElementById('filterableTable');
    if (tableSearch && targetTable) {
        tableSearch.addEventListener('keyup', function () {
            const query = this.value.toLowerCase().trim();
            const rows = targetTable.querySelectorAll('tbody tr');

            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                if (text.includes(query)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    }
});
