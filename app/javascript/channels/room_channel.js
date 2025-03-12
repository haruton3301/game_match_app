import consumer from "./consumer"

document.addEventListener("turbo:load", () => {
  const messagesContainer = document.getElementById("messages")
  if (!messagesContainer) return

  const roomId = messagesContainer.dataset.roomId

  consumer.subscriptions.create({ channel: "RoomChannel", room_id: roomId }, {
    received(data) {
      messagesContainer.insertAdjacentHTML("beforeend", data)
    }
  })
})
