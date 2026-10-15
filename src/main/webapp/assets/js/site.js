```javascript
(function () {

    // ========================================
    // 1. NAVIGATION MENU
    // ========================================
    var toggle = document.querySelector('[data-menu-toggle]');
    var nav = document.querySelector('[data-nav]');

    if (toggle && nav) {

        toggle.addEventListener('click', function () {
            var open = nav.classList.toggle('open');

            toggle.setAttribute('aria-expanded', String(open));
            toggle.setAttribute(
                'aria-label',
                open ? 'Close navigation menu' : 'Open navigation menu'
            );
        });

        var navLinks = nav.querySelectorAll('a');

        for (var i = 0; i < navLinks.length; i++) {
            navLinks[i].addEventListener('click', function () {
                nav.classList.remove('open');
                toggle.setAttribute('aria-expanded', 'false');
                toggle.setAttribute('aria-label', 'Open navigation menu');
            });
        }
    }


    // ========================================
    // 2. BOOKING FORM ELEMENTS
    // ========================================
    var room = document.querySelector('[data-room-type]');
    var guests = document.querySelector('[data-guests]');
    var nightsNode = document.querySelector('[data-nights]');
    var subtotalNode = document.querySelector('[data-subtotal]');
    var totalNode = document.querySelector('[data-total]');
    var rateNode = document.querySelector('[data-rate]');
    var checkin = document.querySelector('[data-checkin]');
    var checkout = document.querySelector('[data-checkout]');


    // ========================================
    // 3. DATE HELPERS
    // ========================================
    var today = new Date();
    today.setHours(0, 0, 0, 0);

    function localISO(date) {
        var year = date.getFullYear();
        var month = String(date.getMonth() + 1);
        var day = String(date.getDate());

        if (month.length < 2) {
            month = '0' + month;
        }

        if (day.length < 2) {
            day = '0' + day;
        }

        return year + '-' + month + '-' + day;
    }

    function parseLocalDate(value) {
        var parts = value.split('-');

        return new Date(
            Number(parts[0]),
            Number(parts[1]) - 1,
            Number(parts[2])
        );
    }


    // ========================================
    // 4. DATE VALIDATION
    // ========================================
    if (checkin) {
        checkin.min = localISO(today);
    }

    if (checkout) {
        var tomorrow = new Date(today.getTime());
        tomorrow.setDate(tomorrow.getDate() + 1);

        checkout.min = localISO(tomorrow);
    }

    if (checkin && checkout) {

        if (checkin.value) {
            var firstDate = parseLocalDate(checkin.value);

            firstDate.setDate(firstDate.getDate() + 1);
            checkout.min = localISO(firstDate);

            if (checkout.value && checkout.value < checkout.min) {
                checkout.value = checkout.min;
            }
        }

        checkin.addEventListener('change', function () {

            if (!checkin.value) {
                return;
            }

            var nextDate = parseLocalDate(checkin.value);
            nextDate.setDate(nextDate.getDate() + 1);

            checkout.min = localISO(nextDate);

            if (checkout.value && checkout.value <= checkin.value) {
                checkout.value = checkout.min;
            }

            updatePrice();
        });

        checkout.addEventListener('change', function () {
            updatePrice();
        });
    }


    // ========================================
    // 5. CURRENCY FORMATTER
    // ========================================
    function money(amount) {
        return '₹' + Math.round(amount).toLocaleString('en-IN');
    }


    // ========================================
    // 6. CALCULATE BOOKING PRICE
    // ========================================
    function updatePrice() {

        if (!room || !nightsNode || !totalNode) {
            return;
        }

        var selectedOption = room.options[room.selectedIndex];
        var rate = 0;

        if (selectedOption && selectedOption.getAttribute('data-rate')) {
            rate = Number(selectedOption.getAttribute('data-rate'));

            if (isNaN(rate) || rate < 0) {
                rate = 0;
            }
        }

        var nights = 0;

        if (checkin && checkout && checkin.value && checkout.value) {

            var startDate = parseLocalDate(checkin.value);
            var endDate = parseLocalDate(checkout.value);

            var difference = endDate.getTime() - startDate.getTime();

            nights = Math.max(0, Math.round(difference / 86400000));
        }

        var total = rate * nights;

        nightsNode.textContent = String(nights);

        if (subtotalNode) {
            subtotalNode.textContent = money(total);
        }

        totalNode.textContent = money(total);

        if (rateNode) {
            rateNode.textContent = money(rate);
        }
    }


    // ========================================
    // 7. UPDATE PRICE WHEN FORM CHANGES
    // ========================================
    if (room) {
        room.addEventListener('change', updatePrice);
    }

    if (guests) {
        guests.addEventListener('change', updatePrice);
    }

    updatePrice();


    // ========================================
    // 8. GALLERY IMAGE MODAL
    // ========================================
    var modal = document.querySelector('[data-gallery-modal]');

    if (modal) {

        var modalImage = modal.querySelector('img');
        var closeButton = modal.querySelector('[data-gallery-close]');
        var galleryButtons = document.querySelectorAll('[data-gallery-image]');

        function closeModal() {
            modal.classList.remove('open');
            modal.setAttribute('aria-hidden', 'true');
            document.body.style.overflow = '';
        }

        for (var j = 0; j < galleryButtons.length; j++) {

            galleryButtons[j].addEventListener('click', function () {

                var image = this.querySelector('img');

                if (!image || !modalImage) {
                    return;
                }

                modalImage.src = image.src;
                modalImage.alt = image.alt;

                modal.classList.add('open');
                modal.setAttribute('aria-hidden', 'false');

                document.body.style.overflow = 'hidden';
            });
        }

        if (closeButton) {
            closeButton.addEventListener('click', closeModal);
        }

        modal.addEventListener('click', function (event) {

            if (event.target === modal) {
                closeModal();
            }
        });

        document.addEventListener('keydown', function (event) {

            if (event.key === 'Escape') {
                closeModal();
            }
        });
    }

})();
```