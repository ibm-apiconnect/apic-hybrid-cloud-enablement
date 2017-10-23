---
title: Install Node.js
toc: false
sidebar: labs_sidebar
folder: labs/env_setup
permalink: /env_setup_install_node.html
summary: The API Connect Toolkit is built on Node.js technology. In this section, you will either install Node.js or upgrade your existing Node.js runtime to the necessary version.
applies_to: [developer]
---

## Check if Node.js is Already Installed

1.  Open a terminal and run the following command:

    ```bash
    node -v
    ```

1.  Verify the output.

    1.  If the command returns an error or a version number less than `v6.10.3`, continue to [Install Node.js](env_setup_install_node.html#install-nodejs) for your operating system.

    1.  If you already have Node.js `v6.10.3` or later, proceed to [Install the API Connect Toolkit](env_setup_install_apic_toolkit.html).

## Install Node.js

Select your Operating System:

<ul id="osTabs" class="nav nav-tabs">
    <li class="active"><a href="#windows" data-toggle="tab">Windows</a></li>
    <li><a href="#macOS" data-toggle="tab">macOS</a></li>
    <li><a href="#linux" data-toggle="tab">Debian or Ubuntu Linux</a></li>
    <li><a href="#other" data-toggle="tab">Other</a></li>
</ul>
<div class="tab-content">
    <div role="tabpanel" class="tab-pane active" id="windows">
        <ol>
          <li>
            <p>The API Connect developer toolkit requires Node.js version 6.10.3. Use the links below to download the installation file for your operating system.</p>

            <p><a href="https://nodejs.org/dist/v6.10.3/node-v6.10.3-x86.msi" target="_blank">32-bit Windows</a></p>

            <p><a href="https://nodejs.org/dist/v6.10.3/node-v6.10.3-x64.msi" target="_blank">64-bit Windows</a></p>
          </li>
          <li>
            <p>Launch the Windows Installer <code class="highlighter-rouge">.msi</code> binary and then follow the prompts to install on your machine.</p>
          </li>
          <li>
            <p>Before moving on, you will need to update your version of <code class="highlighter-rouge">npm</code>. Launch a <code class="highlighter-rouge">Powershell</code> and run the following command:</p>

            <div class="language-bash highlighter-rouge"><pre class="highlight"><button class="codeCopyImg style-scope doc-content" alt=" " role="button" aria-label="copy button" tabindex="0" onclick="copyToClipboard(this.nextSibling)"><svg class="copy--code style-scope doc-content"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="./images/common/bluemix-icons.svg#icon--copy" class="style-scope doc-content"></use></svg></button><code>npm install npm --global</code></pre>
            </div>
          </li>
          <li>
            <p>Proceed to <a href="env_setup_install_docker.html">Install Docker</a>.</p>
          </li>
        </ol>
    </div>

    <div role="tabpanel" class="tab-pane" id="macOS">
            <ol>
              <li>
                <p>Remove any existing versions of node. You will only need to complete these steps if node currently exists.</p>

                <p>To remove node completely from your macOS workstation, copy the following command set and run it in your terminal:</p>

                <div class="language-bash highlighter-rouge"><pre class="highlight"><button class="codeCopyImg style-scope doc-content" alt=" " role="button" aria-label="copy button" tabindex="0" onclick="copyToClipboard(this.nextSibling)"><svg class="copy--code style-scope doc-content"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="./images/common/bluemix-icons.svg#icon--copy" class="style-scope doc-content"></use></svg></button><code>sudo rm /usr/local/bin/npm <span class="o">&amp;&amp;</span> <span class="se">\</span>
sudo rm /usr/local/share/man/man1/node.1 <span class="o">&amp;&amp;</span> <span class="se">\</span>
sudo rm /usr/local/lib/dtrace/node.d <span class="o">&amp;&amp;</span> <span class="se">\</span>
sudo rm -rf ~/.npm <span class="o">&amp;&amp;</span> <span class="se">\</span>
sudo rm -rf ~/.node-gyp <span class="o">&amp;&amp;</span> <span class="se">\</span>
sudo rm /opt/local/bin/node <span class="o">&amp;&amp;</span> <span class="se">\</span>
sudo rm /opt/local/include/node <span class="o">&amp;&amp;</span> <span class="se">\</span>
sudo rm -rf /opt/local/lib/node_modules <span class="o">&amp;&amp;</span> <span class="se">\</span>
sudo rm -rf /usr/local/include/node/</code></pre>
                </div>
              </li>
              <li>
                <p>Run the following command to install the Xcode Command Line Tools:</p>

                <div class="language-bash highlighter-rouge"><pre class="highlight"><button class="codeCopyImg style-scope doc-content" alt=" " role="button" aria-label="copy button" tabindex="0" onclick="copyToClipboard(this.nextSibling)"><svg class="copy--code style-scope doc-content"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="./images/common/bluemix-icons.svg#icon--copy" class="style-scope doc-content"></use></svg></button><code>xcode-select --install</code></pre>
                </div>
              </li>
              <li>
                <p>This will open a dialog asking if you you would like to install the command line tools. Click on the <code class="highlighter-rouge">Install</code> button.</p>
              </li>
              <li>
                <p>Agree to the license and the software will begin installing.</p>
              </li>
              <li>
                <p>Run the following command in your terminal to install the Node Version Manager:</p>

                <div class="language-bash highlighter-rouge"><pre class="highlight"><button class="codeCopyImg style-scope doc-content" alt=" " role="button" aria-label="copy button" tabindex="0" onclick="copyToClipboard(this.nextSibling)"><svg class="copy--code style-scope doc-content"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="./images/common/bluemix-icons.svg#icon--copy" class="style-scope doc-content"></use></svg></button><code>curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash</code></pre>
                </div>
              </li>
              <li>
                <p>To install node 6.10.3, issue this command:</p>

                <div class="language-bash highlighter-rouge"><pre class="highlight"><button class="codeCopyImg style-scope doc-content" alt=" " role="button" aria-label="copy button" tabindex="0" onclick="copyToClipboard(this.nextSibling)"><svg class="copy--code style-scope doc-content"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="./images/common/bluemix-icons.svg#icon--copy" class="style-scope doc-content"></use></svg></button><code>nvm install v6.10.3</code></pre>
                </div>
              </li>
              <li>
                <p>Proceed to <a href="env_setup_install_docker.html">Install Docker</a>.</p>
              </li>
            </ol>
        </div>

    <div role="tabpanel" class="tab-pane" id="linux">
        <ol>
          <li>
            <p>Run the following command in a terminal to install the prerequisite packages:</p>

            <div class="language-bash highlighter-rouge"><pre class="highlight"><button class="codeCopyImg style-scope doc-content" alt=" " role="button" aria-label="copy button" tabindex="0" onclick="copyToClipboard(this.nextSibling)"><svg class="copy--code style-scope doc-content"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="./images/common/bluemix-icons.svg#icon--copy" class="style-scope doc-content"></use></svg></button><code>sudo apt-get install build-essential libssl-dev curl git-core</code></pre>
            </div>
          </li>
          <li>
            <p>Install Node Version Manager by issuing the following command:</p>

            <div class="language-bash highlighter-rouge"><pre class="highlight"><button class="codeCopyImg style-scope doc-content" alt=" " role="button" aria-label="copy button" tabindex="0" onclick="copyToClipboard(this.nextSibling)"><svg class="copy--code style-scope doc-content"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="./images/common/bluemix-icons.svg#icon--copy" class="style-scope doc-content"></use></svg></button><code>curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash</code></pre>
            </div>

            <div class="alert alert-info" role="alert"><i class="fa fa-info-circle"></i> <b>Note:</b> <br>
            When you install <code class="highlighter-rouge">nvm</code> it will also install <code class="highlighter-rouge">npm</code> which is the node package manager used to install Node.js based software modules, including the API Connect Developer Toolkit.
        </div>
          </li>
          <li>
            <p>Close and restart your terminal as indicated in the terminal window, or run this command:</p>

            <div class="language-bash highlighter-rouge"><pre class="highlight"><button class="codeCopyImg style-scope doc-content" alt=" " role="button" aria-label="copy button" tabindex="0" onclick="copyToClipboard(this.nextSibling)"><svg class="copy--code style-scope doc-content"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="./images/common/bluemix-icons.svg#icon--copy" class="style-scope doc-content"></use></svg></button><code><span class="nb">source</span> ~/.profile</code></pre>
            </div>
          </li>
          <li>
            <p>To install node 6.10.3, issue this command:</p>

            <div class="language-bash highlighter-rouge"><pre class="highlight"><button class="codeCopyImg style-scope doc-content" alt=" " role="button" aria-label="copy button" tabindex="0" onclick="copyToClipboard(this.nextSibling)"><svg class="copy--code style-scope doc-content"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="./images/common/bluemix-icons.svg#icon--copy" class="style-scope doc-content"></use></svg></button><code>nvm install v6.10.3</code></pre>
            </div>
          </li>
          <li>
            <p>Proceed to <a href="env_setup_install_docker.html">Install Docker</a>.</p>
          </li>
        </ol>
    </div>

    <div role="tabpanel" class="tab-pane active" id="other">
            <ol>
              <li>
                <p>Follow the instructions for your system on the Node.js website</p>

                <p><a href="https://nodejs.org/en/download/package-manager/" target="_blank">https://nodejs.org/en/download/package-manager/</a></p>
              </li>
              <li>
                <p>Once you've installed Node.js, proceed to <a href="env_setup_install_docker">Install Docker</a>.</p>
              </li>
            </ol>
        </div>
</div>

{% comment %}
## Windows

1.  The API Connect developer toolkit requires Node.js version 6.10.3. Use the links below to download the installation file for your operating system.

    [32-bit Windows](https://nodejs.org/dist/v6.10.3/node-v6.10.3-x86.msi){:target="_blank"}

    [64-bit Windows](https://nodejs.org/dist/v6.10.3/node-v6.10.3-x64.msi){:target="_blank"}

1.  Launch the Windows Installer `.msi` binary and then follow the prompts to install on your machine.

1.  Before moving on, you will need to update your version of `npm`. Launch a `Powershell` and run the following command:

    ```bash
    npm install npm --global
    ```
1.  Proceed to [Install the API Connect Toolkit](env_setup_install_apic_toolkit.html).

## macOS

1.  Remove any existing versions of node. You will only need to complete these steps if node currently exists.

    To remove node completely from your macOS workstation, copy the following command set and run it in your terminal:

    ```bash
    sudo rm /usr/local/bin/npm && \
    sudo rm /usr/local/share/man/man1/node.1 && \
    sudo rm /usr/local/lib/dtrace/node.d && \
    sudo rm -rf ~/.npm && \
    sudo rm -rf ~/.node-gyp && \
    sudo rm /opt/local/bin/node && \
    sudo rm /opt/local/include/node && \
    sudo rm -rf /opt/local/lib/node_modules && \
    sudo rm -rf /usr/local/include/node/
    ```

1.  Run the following command to install the Xcode Command Line Tools:

    ```bash
    xcode-select --install
    ```

1.  This will open a dialog asking if you you would like to install the command line tools. Click on the `Install` button.

1.  Agree to the license and the software will begin installing.

1.  Run the following command in your terminal to install the Node Version Manager:

    ```bash
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
    ```

1.  To install node 6.10.3, issue this command:

    ```bash
    nvm install v6.10.3
    ```

1.  Proceed to [Install the API Connect Toolkit](env_setup_install_apic_toolkit.html#).

## Debian or Ubuntu Linux

1.  Run the following command in a terminal to install the prerequisite packages:

    ```bash
    sudo apt-get install build-essential libssl-dev curl git-core
    ```

1.  Install Node Version Manager by issuing the following command:

    ```bash
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
    ```

    {% include note.html content="
        When you install `nvm` it will also install `npm` which is the node package manager used to install Node.js based software modules, including the API Connect Developer Toolkit.
    " %}

1.  Close and restart your terminal as indicated in the terminal window, or run this command:

    ```bash
    source ~/.profile
    ```

1.  To install node 6.10.3, issue this command:

    ```bash
    nvm install v6.10.3
    ```

1.  Proceed to [Install the API Connect Toolkit](env_setup_install_apic_toolkit.html#).

## Other
1.  Follow the instructions for your system on the Node.js website</p>

    [https://nodejs.org/en/download/package-manager/](https://nodejs.org/en/download/package-manager/){:target="_blank:}

1.  Once you've installed Node.js, proceed to [Install the API Connect Toolkit](env_setup_install_apic_toolkit.html#).

{% endcomment %}
