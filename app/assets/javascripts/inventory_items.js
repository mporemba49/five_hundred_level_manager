$(document).ready(function () {
    $(".inventoryItemCheck").click(function () {
        $(".inventoryItem").prop('checked', $(this).prop('checked'));
    });
});