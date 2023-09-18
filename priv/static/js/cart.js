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
  .map((pizza) => {
    const data = pizza.split("§");
    return {
      id: Number(data[0]),
      name: data[1],
      ingredients: Number(data[2]),
      price: Number(data[3]),
    };
  });

const familyBit =
  1 << ingredients.find((ingredient) => ingredient.name == "Familjepizza").id;

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
  const div = document.createElement("div");
  div.id = i;

  fillPizza(div, pizza, i);

  main.appendChild(div);
});

const match = location.href.match(/#(\d+)/);

if (match) {
  setTimeout(() => {
    document.getElementById(match[1]).scrollIntoView({ behavior: "smooth" });
  }, 100);
}

function fillPizza(div, pizza, i) {
  div.textContent = "";

  const img = document.createElement("img");
  img.src = `/img/${pizza.id}.svg`;

  const h = document.createElement("h2");
  h.innerHTML = pizza.name;

  const span = document.createElement("span");
  span.innerHTML = `${calcPrice(pizza)}:-`;

  const ingredientList = document.createElement("div");
  ingredientList.classList.add("ingredients");

  ingredients
    .filter((ingredient) => (pizza.ingredients & (1 << ingredient.id)) > 0)
    .forEach((ingredient) => {
      const name = document.createElement("span");
      name.innerHTML = ingredient.name;
      ingredientList.appendChild(name);

      const remove = document.createElement("button");
      remove.innerHTML = "Ta bort";
      ingredientList.appendChild(remove);
      remove.addEventListener("click", () => {
        order[i].ingredients &= ~(1 << ingredient.id);
        localStorage.setItem(
          "order",
          order
            .map((x) => `${x.id}§${x.name}§${x.ingredients}§${x.price}`)
            .join("§§")
        );
        span.innerHTML = `${calcPrice(pizza)}:-`;

        fillPizza(div, pizza, i);
      });

      const br = document.createElement("br");
      ingredientList.appendChild(br);
    });

  const select = document.createElement("select");
  select.classList.add("options");
  const noOption = document.createElement("option");
  noOption.value = 0;
  noOption.innerHTML = "Lägg till en ingrediens";
  select.appendChild(noOption);
  ingredients
    .filter((ingredient) => (pizza.ingredients & (1 << ingredient.id)) == 0)
    .forEach((ingredient) => {
      appendOption(
        select,
        ingredient,
        (pizzas[pizza.id - 1].ingredients & (1 << ingredient.id)) == 0
      );
    });

  select.addEventListener("input", (_) => {
    const ingredientId = select.value;
    order[i].ingredients |= 1 << ingredientId;
    localStorage.setItem(
      "order",
      order
        .map((x) => `${x.id}§${x.name}§${x.ingredients}§${x.price}`)
        .join("§§")
    );
    span.innerHTML = `${calcPrice(pizza)}:-`;

    fillPizza(div, pizza, i);
  });

  const remove = document.createElement("button");
  remove.classList.add("remove");
  remove.innerHTML = "Ta bort";
  remove.addEventListener("click", () => {
    order.splice(i, 1);
    if (order.length == 0) localStorage.removeItem("order");
    else
      localStorage.setItem(
        "order",
        order
          .map((x) => `${x.id}§${x.name}§${x.ingredients}§${x.price}`)
          .join("§§")
      );
    location.reload();
  });

  const removeAll = document.createElement("button");
  removeAll.classList.add("clear");
  removeAll.innerHTML = "Töm Varukorg";
  removeAll.addEventListener("click", () => {
    localStorage.clear("order");
    location.reload();
  });

  const info = document.createElement("div");
  info.classList.add("info");

  info.appendChild(h);
  info.appendChild(span);
  info.appendChild(ingredientList);
  info.appendChild(select);
  info.appendChild(remove);
  info.appendChild(removeAll);

  div.appendChild(img);
  div.appendChild(info);
}

function appendOption(list, ingredient, showPrice) {
  const option = document.createElement("option");
  option.value = ingredient.id;
  if (ingredient.name == "Familjepizza") {
    option.innerHTML = `${ingredient.name} - x2`;
  } else if (ingredient.price == 0 || !showPrice) {
    option.innerHTML = `${ingredient.name}`;
  } else {
    option.innerHTML = `${ingredient.name} - ${ingredient.price / 100}:-`;
  }

  list.appendChild(option);
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
