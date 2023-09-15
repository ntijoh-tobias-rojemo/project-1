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

const familyBit =
  1 << ingredients.find((ingredient) => ingredient.name == "Familjepizza").id;

document.querySelectorAll(".order").forEach((order) => {
  console.log(order);

  const orderedPizzas = [];
  order.querySelectorAll(".pizza").forEach((pizza) =>
    orderedPizzas.push({
      id: pizzas[Number(pizza.dataset.template) - 1].id,
      ingredients: Number(pizza.dataset.ingredients),
      price: pizzas[Number(pizza.dataset.template) - 1].price,
    })
  );

  console.log(orderedPizzas);

  order.querySelector(".price").innerHTML = `Total: ${orderedPizzas
    .map(calcPrice)
    .reduce((a, b) => a + b, 0)
    .toFixed(2)}:-`;
});

function calcPrice(pizza) {
  return (
    ((pizza.price +
      ingredients
        .filter((ingredient) => (pizza.ingredients & (1 << ingredient.id)) > 0)
        .filter(
          (ingredient) =>
            (pizzas[pizza.id - 1].ingredients & (1 << ingredient.id)) == 0
        )
        .map((x) => x.price)
        .reduce((a, b) => a + b, 0)) /
      100) *
    ((pizza.ingredients & familyBit) > 0 ? 2 : 1)
  );
}
