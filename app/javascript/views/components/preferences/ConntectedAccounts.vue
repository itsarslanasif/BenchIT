<template lang="">
  <div>
    <p class="text-base"><strong>Connected Accounts</strong></p>
    <p>
      You can connect your Slack account with other apps and services for faster
      sign-in, rich previews of links and more.
      <span class="text-info cursor-pointer">Learn more</span>
    </p>
    <hr class="my-3" />
    <p class="font-semibold">Signed in with Slack</p>
    <p class="px-3 py-2 my-3 bg-gray-50 rounded">
      For now, you can find the apps that you have signed in with slack in your
      <span class="text-info">app management page</span>.
    </p>
    <hr class="my-3" />
    <p class="font-semibold">Links and content from other apps</p>
    <p>
      When you open a link from another app or service, you can use your Slack
      sign-in info to connect your account and see that link’s content. Apps
      will send you a request to connect when you open their links.
    </p>
    <div class="my-3">
      <input type="checkbox" id="connect-to-apps" />
      <label for="connect-to-apps" class="pl-3"
        >Allow Slack to connect with other apps</label
      >
    </div>
    <div>
      <p class="font-semibold">Connected (1)</p>
      <div class="flex justify-between items-center bg-gray-50 rounded my-3">
        <div class="flex items-center px-5 py-3">
          <div class="w-12">
            <img src="../../../assets/images/user.png" class="rounded" />
          </div>
          <div class="pt-1 pl-3 h-12">
            <strong>Loom</strong>
            <p>1 month ago</p>
          </div>
        </div>
        <div class="mr-3 px-3 py-1 border rounded font-semibold">
          <button>Disconnect</button>
        </div>
      </div>
    </div>
  </div>
</template>
