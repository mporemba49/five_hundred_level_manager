document.addEventListener('turbolinks:load', function () {
    $(".activeAccessoryCheck").click(function () {
        $(".activeAccessory").prop('checked', $(this).prop('checked'));
    });
});
document.addEventListener('turbolinks:load', function () {
    $(".inactiveAccessoryCheck").click(function () {
        $(".inactiveAccessory").prop('checked', $(this).prop('checked'));
    });
});
document.addEventListener('turbolinks:load', function () {
    $(".activeClothingCheck").click(function () {
        $(".activeClothing").prop('checked', $(this).prop('checked'));
    });
});
document.addEventListener('turbolinks:load', function () {
    $(".inactiveClothingCheck").click(function () {
        $(".inactiveClothing").prop('checked', $(this).prop('checked'));
    });
});