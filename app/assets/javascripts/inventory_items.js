document.addEventListener('turbolinks:load', function () {
    $(".inventoryItemCheck").click(function () {
        $(".inventoryItem").prop('checked', $(this).prop('checked'));
    });
});