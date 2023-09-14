const ingredients = document
  .getElementById("ingredient-data")
  .innerHTML.split("§§")
  .map((ingredient) => {
    const data = ingredient.split("§");
    return { id: Number(data[0]), name: data[1], price: Number(data[2]) };
  });

const pizzas = document
  .getElementById("pizza-data")
  .innerHTML.split("§§")
  .map((ingredient) => {
    const data = ingredient.split("§");
    return {
      id: Number(data[0]),
      name: data[1],
      ingredients: Number(data[2]),
      price: Number(data[3]),
    };
  });

const order =
  localStorage
    .getItem("order")
    ?.split("§§")
    ?.map((pizza) => {
      const data = pizza.split("§");
      return {
        id: data[0],
        name: data[1],
        ingredients: Number(data[2]),
        price: Number(data[3]),
      };
    }) || [];

const main = document.querySelector("main");

order.forEach((pizza, i) => {
  const elem = document.createElement("div");

  const img = document.createElement("img");
  img.src = `/img/${pizza.id}.svg`;

  const h = document.createElement("h2");
  h.innerHTML = pizza.name;

  const span = document.createElement("span");
  span.innerHTML = pizza.price / 100;

  const ul = document.createElement("ul");
  ingredients
    .filter((x) => pizza.ingredients & (1 << x.id))
    .forEach((ingredient) => {
      appendEntry(ul, i, ingredient);
    });

  elem.appendChild(img);
  elem.appendChild(h);
  elem.appendChild(span);
  elem.appendChild(ul);

  main.appendChild(elem);
});

function appendEntry(list, pizza, ingredient) {
  const li = document.createElement("li");
  li.innerHTML = ingredient.name;
  list.appendChild(li);
}
