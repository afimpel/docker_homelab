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
            renderRows('cacheList_' + idAttr, responseJSON.data.cache.rows, responseJSON.data.cache, renderCache);
            renderRows('mailsList_' + idAttr, responseJSON.data.mailer.rows, responseJSON.data.mailer, renderMail);
        } catch (error) {
            console.error({ error });
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
    let IDmailer = 'mailer_' + idAttr;
    let dataJson = responseJSON.data;
    document.getElementById("active_" + idAttr + "_local").style.display = '';
    document.getElementById("active2_" + idAttr + "_local").style.display = '';
    document.getElementById("display_" + idAttr + "_local").style.display = 'none';
    document.getElementById(IDcache).innerHTML = dataJson.cache.uptime;
    document.getElementById(IDcache).dataset.bsOriginalTitle = dataJson.cache.server.name + " " + dataJson.cache.server.version + " ➤ Uptime : " + dataJson.cache.uptime + " ➤ Total : " + dataJson.cache.counter + " keys";
    document.getElementById(IDdatabase).innerHTML = dataJson.database.uptime;
    document.getElementById(IDdatabase).dataset.bsOriginalTitle = dataJson.database.server.name + " " + dataJson.database.server.version + " ➤ Uptime : " + dataJson.database.uptime + " ➤ Total : " + dataJson.database.counter + " dbs";
    if (dataJson.mailer.unread == 0) {
        document.getElementById(IDmailer).innerHTML = dataJson.mailer.uptime;
    } else {
        document.getElementById(IDmailer).innerHTML = dataJson.mailer.unread + " New ➤ " + dataJson.mailer.uptime;
    }

    document.getElementById(IDmailer).dataset.bsOriginalTitle = dataJson.mailer.server.name + " " + dataJson.mailer.server.version + " ➤ Uptime : " + dataJson.mailer.uptime + " ➤ Total : " + dataJson.mailer.counter + " mails";
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

function renderCache(item, clone, index, extraJSON) {
    clone.querySelector('.nombre').textContent = item;
}

function renderMail(item, clone, index, extraJSON) {
    const btn = clone.querySelector('button');
    const mails_icon = clone.querySelector('.mails_icon');
    const mails_icon2 = clone.querySelector('.mails_icon2');
    const mails_fecha = clone.querySelector('.mails_fecha');
    if (item.Read) {
        mails_icon.classList.add(`bi-envelope-open-fill`);
        mails_icon2.classList.add(`bi-envelope-open-fill`);
    } else {
        mails_icon.classList.add(`bi-envelope-fill`);
        mails_icon2.classList.add(`bi-envelope-fill`);
    }

    mails_icon2.parentNode.setAttribute("href", extraJSON.link + "view/" + item.ID);
    mails_fecha.textContent = formatDate(item.Created);
    const mails_form = clone.querySelector('.mails_form');
    const mails_to = clone.querySelector('.mails_to');
    const mails_cc = clone.querySelector('.mails_cc');
    const mails_bcc = clone.querySelector('.mails_bcc');
    const mails_replayto = clone.querySelector('.mails_replayto');
    const mails_content = clone.querySelector('.mails_content');
    mails_content.textContent = item.Snippet;

    if (item.From.Name == "") {
        mails_form.textContent = item.From.Address;
    } else {
        mails_form.textContent = `${item.From.Name} <${item.From.Address}>`;
    }
    let mails_tos = [];
    let addrs = null;
    item.To.forEach((data, i) => {
        if (data.Name == "") {
            mails_tos.push(data.Address);
        } else {
            mails_tos.push(`${data.Name} <${data.Address}>`);
        }
    });
    mails_to.textContent = mails_tos.join(", ");
    if (item.Cc === null) {
        mails_cc.style.display = "none";
    } else {
        addrs = mails_cc.querySelector('.addrs');
        mails_tos = [];
        item.Cc.forEach((data, i) => {
            if (data.Name == "") {
                mails_tos.push(data.Address);
            } else {
                mails_tos.push(`${data.Name} <${data.Address}>`);
            }
        });
        addrs.textContent = mails_tos.join(", ");
    }
    if (item.Bcc === null) {
        mails_bcc.style.display = "none";
    } else {
        addrs = mails_bcc.querySelector('.addrs');
        mails_tos = [];
        item.Bcc.forEach((data, i) => {
            if (data.Name == "") {
                mails_tos.push(data.Address);
            } else {
                mails_tos.push(`${data.Name} <${data.Address}>`);
            }
        });
        addrs.textContent = mails_tos.join(", ");
    }
    if (item.ReplyTo.length == 0) {
        mails_replayto.style.display = "none";
    } else {
        addrs = mails_replayto.querySelector('.addrs');
        mails_tos = [];
        item.ReplyTo.forEach((data, i) => {
            if (data.Name == "") {
                mails_tos.push(data.Address);
            } else {
                mails_tos.push(`${data.Name} <${data.Address}>`);
            }
        });
        addrs.textContent = mails_tos.join(", ");
    }

    btn.setAttribute('data-bs-target', `#collapse_${index}`);
    btn.setAttribute('aria-controls', `collapse_${index}`);
    const panel = clone.querySelector('.collapse');
    if (panel) panel.id = `collapse_${index}`;
    clone.title = "    ✉️ " + formatDate(item.Created) + " :: " + item.Subject + " ✉️";
    clone.querySelector('.nombre').textContent = item.Subject;
}

function renderRows(idAttr, responseJSON, extraJSON, func) {

    const containerDiv = document.getElementById(idAttr + '_div');
    if (responseJSON.length == 0) {
        containerDiv.style.display = "none";
    } else {
        containerDiv.style.display = "";
        const container = document.getElementById(idAttr + '_rows');
        const template = document.getElementById(idAttr + '_clone');
        const counter = document.getElementById(idAttr + '_counter');
        counter.textContent = responseJSON.length;
        container.querySelectorAll(`.${idAttr}-item`).forEach(el => el.remove());

        responseJSON.forEach((item, index) => {
            const clone = template.cloneNode(true);
            clone.id = `${idAttr}_clone_${index}`;
            clone.classList.add(`${idAttr}-item`);
            clone.style.display = '';
            func(item, clone, index, extraJSON);
            container.appendChild(clone);
        });
    }

}

function formatDate(fechaString) {
    const dateOrigin = new Date(fechaString);

    const nowDate = new Date();

    const esMismoDia =
        dateOrigin.getDate() === nowDate.getDate() &&
        dateOrigin.getMonth() === nowDate.getMonth() &&
        dateOrigin.getFullYear() === nowDate.getFullYear();

    const locale = navigator.language || 'en-US';

    if (esMismoDia) {
        const todayHours = dateOrigin.toLocaleTimeString(locale, {
            hour: '2-digit',
            minute: '2-digit',
            hour12: false
        });
        return `${todayHours}`;
    } else {
        const dateFormated = dateOrigin.toLocaleDateString(locale, {
            day: '2-digit',
            month: '2-digit'
        });
        return `${dateFormated}`;
    }
}
