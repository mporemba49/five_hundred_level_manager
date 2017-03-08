$(document).ready(function () {
    $(".activeAccessoryCheck").click(function () {
        $(".activeAccessory").prop('checked', $(this).prop('checked'));
    });
});
$(document).ready(function () {
    $(".inactiveAccessoryCheck").click(function () {
        $(".inactiveAccessory").prop('checked', $(this).prop('checked'));
    });
});
$(document).ready(function () {
    $(".activeClothingCheck").click(function () {
        $(".activeClothing").prop('checked', $(this).prop('checked'));
    });
});
$(document).ready(function () {
    $(".inactiveClothingCheck").click(function () {
        $(".inactiveClothing").prop('checked', $(this).prop('checked'));
    });
});