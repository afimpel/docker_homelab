function listSitesURL(itemsite, itemsiteURL) {
    // console.log(itemsite, itemsiteURL);
    dataUrl(itemsiteURL, itemsite);
}

function toggleThemeMenu() {
    let themeMenu = document.querySelector('#theme-menu');
    var bsTheme = localStorage.getItem("bsTheme");
    var bsThemeCss = localStorage.getItem("bsThemeCss");
    console.log(bsTheme, bsThemeCss);
    if (bsThemeCss == null) {
        localStorage.setItem("bsThemeCss", "bi-sun-fill");
    }
    if (bsTheme) {
        document.documentElement.setAttribute('data-bs-theme', bsTheme);
        if (bsTheme == "dark") {
            themeMenu.children[0].classList.replace("bi-sun-fill", bsThemeCss);
        }
    }
    if (!themeMenu) return;

    document.querySelectorAll('[data-bs-theme-value]').forEach(value => {
        value.addEventListener('click', () => {
            var bsThemeCss = localStorage.getItem("bsThemeCss");
            const theme = value.getAttribute('data-bs-theme-value');
            const themeCss = value.getAttribute('data-bs-theme-style');
            themeMenu.children[0].classList.replace(bsThemeCss, themeCss);
            localStorage.setItem("bsTheme", theme);
            localStorage.setItem("bsThemeCss", themeCss);
            document.documentElement.setAttribute('data-bs-theme', theme);
        });
    });
}

async function obtenerTituloDeUrl(url, idAttr) {
    try {
        const response = await fetch(url);
        if (!response.ok) {
            console.error(`Error al obtener la URL: ${response.status} ${response.statusText}`);
            return null;
        }
        const htmlText = await response.text();
        const parser = new DOMParser();
        const doc = parser.parseFromString(htmlText, 'text/html');
        const title = doc.title;
        //console.log(title);
        const url2 = new URL(url);
        let urlHostname = url2.hostname;
        document.getElementsByName(idAttr).forEach(item => {
            item.innerHTML = title;
        });
        try {
            document.getElementsByName(idAttr + "_tooltip").forEach(item => {
                let itemsTitlesText = ""
                let itemsTitles = item.dataset.title;
                if (itemsTitles != undefined) {
                    itemsTitlesText = itemsTitles + " ➤ ";
                }
                item.dataset.bsOriginalTitle = "🌐 " + itemsTitlesText + urlHostname + " ➤ " + title;
            });
        } catch (error) {
            document.getElementsByName(idAttr).forEach(item => {
                item.title = "🌐 " + urlHostname + " ➤ " + title;
            });
        }
        return title || null;

    } catch (error) {
        document.getElementsByName(idAttr).forEach(item => {
            item.style.display = 'none';
        });
        console.error(`Ocurrió un error al procesar la URL '${url}':`, error);
        return null;
    }
}
function dataUrl(url, id) {
    obtenerTituloDeUrl(url, id).then(title => {
        if (!title) {
            console.log('No se pudo obtener el título de la URL inexistente (esperado).');
        }
    });
}
async function obtenerUptimeUrl(url, idAttr) {
    try {
        const response = await fetch(url);
        if (!response.ok) {
            console.error(`Error al obtener la URL: ${response.status} ${response.statusText}`);
            return null;
        }
        let responseJSON = await response.json();
        try {
            datetimeID(idAttr, responseJSON);
            responseID(idAttr, responseJSON);
        } catch (error) {
            console.error('error :>> ', error);
        }
        return responseJSON.data.datetime;

    } catch (error) {
        // document.getElementById(idAttr).style.display = 'none';
        console.error(`Ocurrió un error al procesar la URL '${url}':`, error);
        return null;
    }
}
function responseID(idAttr, responseJSON) {
    let IDcache = 'cache_' + idAttr;
    let IDdatabase = 'database_' + idAttr;
    let dataJson = responseJSON.data;
    document.getElementById("active_" + idAttr + "_local").style.display = '';
    document.getElementById("active2_" + idAttr + "_local").style.display = '';
    document.getElementById("display_" + idAttr + "_local").style.display = 'none';
    document.getElementById(IDcache).innerHTML = dataJson.cache.uptime;
    document.getElementById(IDcache).dataset.bsOriginalTitle = dataJson.cache.server.name + " ➤ Uptime : " + dataJson.cache.uptime;
    document.getElementById(IDdatabase).innerHTML = dataJson.database.uptime;
    document.getElementById(IDdatabase).dataset.bsOriginalTitle = dataJson.database.server.name + " ➤ Uptime : " + dataJson.database.uptime;
    console.log('Response ➤ ', idAttr, "|", dataJson.cache.server.name + " ➤ Uptime : " + dataJson.cache.uptime, "|", dataJson.database.server.name + " ➤ Uptime : " + dataJson.database.uptime);
}

function datetimeID(idAttr, responseJSON) {
    let IDdatetime = 'datetime_' + idAttr;
    let dataJson = responseJSON.data;
    document.getElementById(IDdatetime).innerHTML = dataJson.datetime;
    document.getElementById(IDdatetime + "_tooltip").dataset.bsOriginalTitle = "DateTime : " + dataJson.datetime;
    console.log('DATE ➤ ', idAttr, '| DateTime ➤ ', dataJson.datetime);
}

function dataUptimeUrl(url, id) {
    obtenerUptimeUrl(url, id).then(title => {
        if (!title) {
            document.getElementById("display_" + id + "_local").style.display = 'flex';
            document.getElementById("active_" + id + "_local").style.display = 'none';
            document.getElementById("active2_" + id + "_local").style.display = 'none';
            console.error(id, " Offline ...");
        }
    });
}

