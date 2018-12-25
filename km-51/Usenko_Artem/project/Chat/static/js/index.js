window.onload = function () {

    const input = document.getElementById("search");
    input.addEventListener("keyup", function (event) {

        event.preventDefault();
        if (event.keyCode === 13) {
            showSearchResult(input.value)
        }
    });

    fetch('/user/chats')
        .then(
            function (response) {

                // Examine the text in the response
                response.json().then(function (data) {
                    let chats = document.getElementById("chatContainer");
                    data.forEach(item => {
                        return chats.appendChild(createHtmlChat(item[0], item[1]));
                    });

                });
            }
        )
        .catch(function (err) {
            console.log('Fetch Error :-S', err);
        });
};

function createChat() {
    const chatName = document.getElementById("chatName").value;
    fetch('/user/new-chat/' + chatName)
        .then(
            function (response) {

            }
        )
        .catch(function (err) {
            console.log('Fetch Error :-S', err);
        });
}


function loadMessage(chatid) {
    fetch('/user/chat-message/' + chatid)
        .then(
            function (response) {
                document['message-form'].action = "/message/new/" + chatid;
                response.json().then(function (data) {

                    let message = document.getElementById("message-container");
                    while (message.firstChild) {
                        message.removeChild(message.firstChild);
                    }
                    data.forEach(item => {
                        return message.appendChild(createHtmlMessage(item[0], item[2], item[1], item[3], item[4]));
                    });
                });
            }
        )
        .catch(function (err) {
            console.log('Fetch Error :-S', err);
        });
}


function createHtmlMessage(messageText, messageDate, fileUrl, isUserMessage, messageid) {
    const div = document.createElement("div");
    div.className = "row";
    div.style = "min-height: 4em; margin-bottom: 1em;";

    const userMessageDiv = createMessageDiv();
    const anotherMessageDiv = createMessageDiv();
    anotherMessageDiv.className += " another_message";
    userMessageDiv.className += " user_message";
    const messageHtml = "<p class='col-6'>" + messageText + "</p> " +
        "<button onclick=deleteMessage(" + messageid + ")> delete </button>" +
        "<button data-toggle='modal' onclick=updateMessageModal(" + messageid + ",'" + messageText + "')> Update </button>" +
        "<p>" + messageDate + "</p>";
    if (isUserMessage)
        userMessageDiv.innerHTML = messageHtml;
    else
        anotherMessageDiv.innerHTML = messageHtml;

    div.appendChild(anotherMessageDiv);
    div.appendChild(userMessageDiv);

    if (fileUrl !== "None" && fileUrl) {
        const userMessageDiv = createMessageDiv();
        const anotherMessageDiv = createMessageDiv();
        anotherMessageDiv.className += " another_message_file";
        userMessageDiv.className += " user_message_file";
        document.createElement("a");

        if (isUserMessage) {
            userMessageDiv.innerHTML = "<i class=\"fas fa-file\"></i>" + fileUrl;
            userMessageDiv.onclick = function () {
                loadFile(messageid, fileUrl)
            }
        } else {
            anotherMessageDiv.innerHTML = "<i class=\"fas fa-file\"></i>" + fileUrl;
            anotherMessageDiv.onclick = function () {
                loadFile(messageid, fileUrl)
            }
        }
        div.appendChild(anotherMessageDiv);
        div.appendChild(userMessageDiv);
    }

    return div;
}

function loadFile(messageid, fileUrl) {
    let filename = fileUrl.split("\\")[2];
    return fetch('/get/file/' + messageid, {
        method: 'GET',
    }).then(function (resp) {
        return resp.blob();
    }).then(function (blob) {
        download(blob, filename);
    });

}

function createMessageDiv() {
    const div = document.createElement("div");
    div.className = "col-6";
    return div;
}

function showSearchResult(name) {
    fetch('/find/chats/' + name)
        .then(
            function (response) {

                response.json().then(function (data) {
                    let chats = document.getElementById("chatContainer");
                    while (chats.firstChild) {
                        chats.removeChild(chats.firstChild);
                    }
                    data.forEach(item => {
                        return chats.appendChild(createHtmlChatForAdd(item[0], item[1]));
                    });

                });
            }
        )
        .catch(function (err) {
            console.log('Fetch Error :-S', err);
        });
}

function addChat(chatid) {
    fetch('/add/chat/' + chatid)
        .then(
            function (response) {

                alert("Successful add chat");
                location.reload();
            }
        )
        .catch(function (err) {
            alert("Cannot add chat")
        });
}

function updateMessageModal(messageid, messageText) {
    document.getElementById("updateMessage").value = messageText;
    document.getElementById("buttonUpdateMessage").onclick = function () {
        updateMessage(messageid, messageText)
    };
    $('#messageUpdateModal').modal('show');
}

function updateMessage(messageid, messageTextOld) {
    let messageText = document.getElementById("updateMessage").value;
    if (messageTextOld === messageText) return;
    fetch('/message/update/' + messageid + '/' + messageText)
        .then(
            function (response) {

                alert("Successful update message");
                location.reload();
            }
        )
        .catch(function (err) {
            alert("Cannot add chat")
        });
}

function deleteMessage(messageid) {
    fetch('/message/delete/' + messageid)
        .then(
            function (response) {

                alert("Successful delete message");
                location.reload();
            }
        )
        .catch(function (err) {
            alert("Cannot delete message")
        });
}

function createHtmlChat(chatName, chatid) {
    const div = document.createElement("div");
    div.innerHTML = "<b>Chat name:</b>  &nbsp&nbsp&nbsp" + chatName;
    div.className = "col-12 chat-container";
    div.onclick = function () {
        loadMessage(chatid);
        document.getElementById("leaveFromChat").href = "/user/leave/" + chatid;
    };
    return div;
}


function createHtmlChatForAdd(chatName, chatid) {
    const div = document.createElement("div");
    div.innerHTML = "<b>Chat name:</b>  &nbsp&nbsp&nbsp" + chatName;
    div.className = "col-12 chat-container chat-with-tooltip";
    div.setAttribute("data-title", "click to add chat");
    div.onclick = function () {
        addChat(chatid)
    };
    return div;
}