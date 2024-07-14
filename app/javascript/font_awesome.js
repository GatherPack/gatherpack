const iconsQuery = `
{
    release (version: "6.x") {
        icons (license: "free") {
            id
            membership {
                free
            }
        }
    }
}
`

async function sendQuery(query) {
    return await (await fetch("https://api.fontawesome.com", {
        method: "POST",
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({"query":query.replace("\n", "")})
      })).json() 
}

function searchIcons(query, limit=15) {
    let queryTerms = query.split(/-|_| /);

    let sortedResults = [];
    for (let i = 0; i < queryTerms.length * 2 + 1; i++) {
        sortedResults.push([])
    }
    let matchedResults = 0;
    window.icons.forEach(icon => {
        var iconMatch = queryTerms.length * 2;
        queryTerms.forEach(term => {
            term = term.toLowerCase();
            if (icon == term) iconMatch -= 1;
            if (icon.includes(term)) iconMatch -= 1;
        });
        if (iconMatch != queryTerms.length) {
            matchedResults++;
        }
        sortedResults[iconMatch].push(icon);
    });
    let finalResults = [];
    for (let i = 0; i < sortedResults.length; i++) {
        for (let j = 0; j < sortedResults[i].length; j++) {
            if (i != sortedResults.length - 1 || matchedResults == 0) {
                finalResults.push(sortedResults[i][j]);
                limit--;
                if (limit == 0) return finalResults;
            }
        }
    }
    return finalResults;
}
window.searchIcons = searchIcons;

function setListValues(list, values, elem_type="li", elem_modifier=null) {
    list.innerHTML = "";
    values.forEach(value => {
        var elem = document.createElement(elem_type);
        elem.innerText = value;
        if (elem_modifier != null) {
            elem_modifier(elem);
        }
        list.appendChild(elem);
    });
};

document.addEventListener("turbo:load", async ev => {
    const raw_icons = (await sendQuery(iconsQuery)).data.release.icons;
    const icons = raw_icons
        .filter(icon => icon.membership.free.includes("solid"))
        .map(icon => icon.id);
    window.icons = icons;

    document.querySelectorAll("input.icon").forEach(icon => {
        let list = icon.parentNode.nextSibling;
        let inputFunc = ev => {
            let iconType = icons.includes(icon.value) ? icon.value : "circle-question";
            icon.parentElement.firstChild.setAttribute("data-icon", iconType);

            setListValues(list, searchIcons(icon.value, 6), "div", elem => {
                let iconElem = document.createElement("i");
                iconElem.classList.add("fa-solid", "fa-" + elem.innerText);
                elem.innerHTML = "&emsp;" + elem.innerText;
                elem.prepend(iconElem);
                elem.addEventListener("click", ev => {
                    icon.value = elem.innerText.trim();
                    inputFunc(null);
                    icon.focus();
                });
                elem.addEventListener("mousedown", ev => {
                    ev.preventDefault(); 
                    ev.stopPropagation()
                });
            });
        }
        icon.parentNode.parentNode.addEventListener("focusin", ev => {
            list.style.display = "inherit";
        });
        icon.parentNode.parentNode.addEventListener("focusout", ev => {
            list.style.display = "none";
        });
        icon.addEventListener("input", inputFunc);
        inputFunc(null);
    });

    let badges = document.getElementsByClassName("badge");
    for (let i = 0; i < badges.length; i++) {
        const badge = badges[i];
        if (icons.includes(badge.innerText)) {
            let elem = document.createElement('i');
            elem.classList.add("fa-solid", "fa-" + badge.innerText);
            badge.innerHTML = "";
            badge.appendChild(elem);
        }
    }
});