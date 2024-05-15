const characterId = "2";

async function main() {
    const url = `https://swapi.dev/api/people/${characterId}/`;
    const res = await fetch(url);
    const json = await res.json();
    console.log(json);
}

main()