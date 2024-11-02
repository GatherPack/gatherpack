function search(items, query, limit=15) {
    let queryTerms = query.split(/-|_| /);

    let sortedResults = [];
    for (let i = 0; i < queryTerms.length * 2 + 1; i++) {
        sortedResults.push([])
    }
    let matchedResults = 0;
    items.forEach(icon => {
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

window.search = search;