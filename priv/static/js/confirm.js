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

const familyBit =
  1 << ingredients.find((ingredient) => ingredient.name == "Familjepizza").id;

const main = document.querySelector("main");

order.forEach((pizza, i) => {
  const elem = document.createElement("div");

  const img = document.createElement("img");
  img.src = `/img/${pizza.id}.svg`;

  const h = document.createElement("h2");
  h.innerHTML = pizza.name;

  const span = document.createElement("span");
  span.innerHTML = `${calcPrice(pizza)}:-`;

  const ingredientList = document.createElement("div");
  ingredientList.classList.add("ingredients");

  ingredients
    .filter((x) => pizza.ingredients & (1 << x.id))
    .forEach((ingredient) => {
      appendEntry(ingredientList, i, ingredient);
    });

  const info = document.createElement("div");
  info.classList.add("info");

  info.appendChild(h);
  info.appendChild(span);
  info.appendChild(ingredientList);

  elem.appendChild(img);
  elem.appendChild(info);

  main.appendChild(elem);
});

document.getElementById("total").innerHTML = `Total: ${order
  .map(calcPrice)
  .reduce((a, b) => a + b, 0)}:-`;

function appendEntry(list, pizza, ingredient) {
  const p = document.createElement("p");
  p.innerHTML = ingredient.name;
  list.appendChild(p);
}

function calcPrice(pizza) {
  return (
    ((pizza.price +
      ingredients
        .filter((ingredient) => (pizza.ingredients & (1 << ingredient.id)) > 0)
        .filter(
          (ingreditent) =>
            (pizzas[pizza.id - 1].ingredients & (1 << ingreditent.id)) == 0
        )
        .map((x) => x.price)
        .reduce((a, b) => a + b, 0)) /
      100) *
    ((pizza.ingredients & familyBit) > 0 ? 2 : 1)
  );
}

document.getElementById("send").addEventListener("click", () => {
  const req = new XMLHttpRequest();
  req.open("POST", `/orders/new`, true);
  req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  req.send(`order=${localStorage.getItem("order")}`);
  localStorage.clear();
  location.assign("/");
});
