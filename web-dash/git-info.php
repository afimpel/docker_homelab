<?php
$titleNavs="Git Information";
include "./inc/head.php";
$jsonString = file_get_contents('json-help.json');
$objVersion = json_decode(file_get_contents('version.json'));
function filterObjectsByTag(array $objects, string $tagToFind, string $tagPropertyName = 'tags'): array
{
    $filteredObjects = [];
    foreach ($objects as $object) {
        if (property_exists($object, $tagPropertyName) && is_array($object->$tagPropertyName)) {
            if (in_array($tagToFind, $object->$tagPropertyName, true) && in_array($object->mode, ['on','both'], true)) {
                $filteredObjects[] = $object;
            }
        }
    }
    return $filteredObjects;
}

?>
    <div class="container-fluid py-2">
        <div class="row m-1">
            <div class="col-12 mb-3">
                <h3 class="title is-3 has-text-centered border-bottom border-primary d-flex p-1 shadow" translate="no" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-original-title="Git Information">
                    <span><i class="bi bi-github me-2"></i> Git Information</span>
                    <a href="./" style="font-size: small;" class="me-2 ms-auto my-auto px-4 py-0 shadow btn btn-outline-secondary btn-sm">back to HOME</a>
                </h3>
            </div>
            <div class="col-12">
                <div class="p-0 m-0 shadow">
                    <div class="m-0 p-0 accordion" id="accordionExample">
                    <?php
                    // Obtener elementos de la página actual

                    foreach ($objVersion->gitArray as $key => $item) {
                        $collapsed = "collapsed";
                        $showA = "";
                        if ($key == 0) {
                        $collapsed = "";
                        $showA = "show";
                        }
                    ?>
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="heading<?= $key; ?>">
                                <button class="accordion-button git-info <?= $collapsed; ?>" type="button" data-bs-toggle="collapse" data-bs-target="#collapse<?= $key; ?>" aria-expanded="false" aria-controls="collapse<?= $key; ?>">
                                    <i class="bi bi-git me-2"></i>
                                    <?php echo "<b class='me-2' style='display: block ruby;'>" . $item->abbreviated_commit . " ➤ </b>" . $item->subject; ?>
                                </button>
                            </h2>
                            <div id="collapse<?= $key; ?>" class="accordion-collapse collapse <?= $showA; ?>" aria-labelledby="heading<?= $key; ?>" data-bs-parent="#accordionExample" style="background: linear-gradient(180deg, rgba(255, 187, 0, 0.2) 0%, rgba(255, 0, 0, 0) 10%, rgba(3, 139, 207, 0) 90%, rgba(0, 212, 255, 0.2) 100%);">
                                <div class="accordion-body row p-1 m-0">
                                    <i class="col-1 bi bi-github m-auto" style="font-size: 600%; text-align: center;"></i>
                                    <div class="col p-2 m-0">
                                        <table class="table table-bordered m-0 p-0">
                                            <tbody>
                                                <tr>
                                                    <td class="py-1 px-4 col-3">
                                                        <i class="bi bi-person-vcard me-3"></i> Author:
                                                    </td>
                                                    <td class="py-1 px-4">
                                                        <?php echo $item->author->name . " ( " . $item->author->email . " )"; ?>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="py-1 px-4 col-3">
                                                        <i class="bi bi-git me-3"></i> Commit hash:
                                                    </td>
                                                    <td class="py-1 px-4"><?php echo $item->commit . " ( " . $item->abbreviated_commit . " )"; ?></td>
                                                </tr>
                                                <tr>
                                                    <td class="py-1 px-4 col-3">
                                                        <i class="bi bi-calendar4-event me-3"></i> DATE:
                                                    </td>
                                                    <td class="py-1 px-4">
                                                        <?php echo $item->date_short." ( ".$item->commiter->date." )"; ?>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="py-1 px-4" colspan="2">
                                                        <?php echo strip_tags($item->subject); ?>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <?php
                    }
                    ?>
                    </div>
                </div>
            </div>
        </div>
    </div>
<?php
include "./inc/footer.php";
?>
