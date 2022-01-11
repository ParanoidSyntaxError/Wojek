// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Utility contracts
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// ERC721 standards
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

interface IERC721Metadata is IERC721 {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overriden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `_data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _balances[to] += 1;
        _owners[tokenId] = to;

        //emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits a {ApprovalForAll} event.
     */
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }
}

library WojekHelper
{
    string internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    function dirtyRandom(uint256 seed, address sender) internal view returns (uint256)
    {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, sender, seed)));
    }

    function splitSVG(uint32 svg, uint32 index) internal pure returns (uint256)
    {
        return (svg / (10 ** (10 - (index * 2) - 2))) % 100;
    }

    function splitHash(uint256 hash, uint256 hashLength, uint256 attributeIndex) internal pure returns (uint256)
    {
        return ((hash - 10 ** hashLength) / (10 ** (hashLength - (attributeIndex * 3) - 3))) % 1000;
    }

    function toString(uint256 value) internal pure returns (string memory) 
    {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function encode(bytes memory data) internal pure returns (string memory) 
    {
        if (data.length == 0) return "";

        // load the table into memory
        string memory table = TABLE;

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((data.length + 2) / 3);

        // add some extra buffer at the end required for the writing
        string memory result = new string(encodedLen + 32);

        assembly {
            // set the actual output length
            mstore(result, encodedLen)

            // prepare the lookup table
            let tablePtr := add(table, 1)

            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

            // result ptr, jump over length
            let resultPtr := add(result, 32)

            // run over the input, 3 bytes at a time
            for {

            } lt(dataPtr, endPtr) {

            } {
                dataPtr := add(dataPtr, 3)

                // read 3 bytes
                let input := mload(dataPtr)

                // write 4 characters
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(6, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(input, 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
            }

            // padding with '='
            switch mod(mload(data), 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }
        }

        return result;
    }
}

contract Wojek is ERC721, Ownable
{
    struct Attribute 
    {
        string trait;
        string value;
        uint32 rectCount;
        uint32[] svg;
    }

    string private constant _svgHeader = "<svg id='wojek-svg' xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 50 50' transform='scale(";
    string private constant _svgStyles = "<style>#wojek-svg{shape-rendering: crispedges;}.w10{fill:#000000}.w11{fill:#ffffff}.w12{fill:#00aaff}.w13{fill:#ff0000}.w14{fill:#ff7777}.w15{fill:#ff89b9}.w16{fill:#fff9e5}.w17{fill:#fff9d5}.w18{fill:#93c63b}.w19{fill:#ff6a00}.w20{fill:#808080}.w21{fill:#a94d00}.w22{fill:#00ffff}.w23{fill:#00ff00}.w24{fill:#B2B2B2}.w25{fill:#267F00}.w26{fill:#5B7F00}.w27{fill:#7F3300}.w28{fill:#A3A3A3}";

    string private _background = "<rect class='w50' x='00' y='00' width='50' height='50'/>";
    string private _wojakFill = "<rect class='w51' x='15' y='05' width='19' height='45'/><rect class='w51' x='17' y='03' width='18' height='02'/><rect class='w51' x='34' y='05' width='04' height='37'/><rect class='w51' x='38' y='07' width='02' height='33'/><rect class='w51' x='40' y='09' width='02' height='29'/><rect class='w51' x='42' y='14' width='02' height='20'/><rect class='w51' x='44' y='25' width='01' height='05'/><rect class='w51' x='13' y='07' width='02' height='24'/><rect class='w51' x='11' y='11' width='02' height='15'/><rect class='w51' x='34' y='46' width='12' height='04'/><rect class='w51' x='46' y='49' width='03' height='01'/><rect class='w51' x='34' y='45' width='01' height='01'/><rect class='w51' x='46' y='48' width='01' height='01'/><rect class='w51' x='00' y='47' width='15' height='03'/><rect class='w51' x='05' y='45' width='10' height='02'/><rect class='w51' x='11' y='43' width='04' height='02'/><rect class='w51' x='13' y='39' width='02' height='04'/>";
    string private _wojakOutline = "<rect class='w10' x='00' y='47' width='01' height='01'/><rect class='w10' x='01' y='46' width='04' height='01'/><rect class='w10' x='05' y='45' width='03' height='01'/><rect class='w10' x='08' y='44' width='03' height='01'/><rect class='w10' x='11' y='43' width='01' height='01'/><rect class='w10' x='12' y='42' width='01' height='01'/><rect class='w10' x='13' y='39' width='01' height='03'/><rect class='w10' x='14' y='37' width='01' height='02'/><rect class='w10' x='15' y='32' width='01' height='05'/><rect class='w10' x='14' y='31' width='01' height='01'/><rect class='w10' x='13' y='29' width='01' height='02'/><rect class='w10' x='12' y='26' width='01' height='03'/><rect class='w10' x='11' y='24' width='01' height='02'/><rect class='w10' x='10' y='14' width='01' height='10'/><rect class='w10' x='11' y='11' width='01' height='03'/><rect class='w10' x='12' y='08' width='01' height='03'/><rect class='w10' x='13' y='07' width='01' height='01'/><rect class='w10' x='14' y='06' width='01' height='01'/><rect class='w10' x='15' y='05' width='01' height='01'/><rect class='w10' x='16' y='04' width='01' height='01'/><rect class='w10' x='17' y='03' width='03' height='01'/><rect class='w10' x='20' y='02' width='11' height='01'/><rect class='w10' x='31' y='03' width='04' height='01'/><rect class='w10' x='35' y='04' width='02' height='01'/><rect class='w10' x='37' y='05' width='01' height='01'/><rect class='w10' x='38' y='06' width='01' height='01'/><rect class='w10' x='39' y='07' width='01' height='01'/><rect class='w10' x='40' y='08' width='01' height='01'/><rect class='w10' x='41' y='09' width='01' height='02'/><rect class='w10' x='42' y='11' width='01' height='03'/><rect class='w10' x='43' y='14' width='01' height='03'/><rect class='w10' x='44' y='17' width='01' height='08'/><rect class='w10' x='45' y='25' width='01' height='05'/><rect class='w10' x='44' y='30' width='01' height='02'/><rect class='w10' x='43' y='32' width='01' height='02'/><rect class='w10' x='42' y='34' width='01' height='01'/><rect class='w10' x='41' y='35' width='01' height='03'/><rect class='w10' x='40' y='38' width='01' height='01'/><rect class='w10' x='39' y='39' width='01' height='01'/><rect class='w10' x='38' y='40' width='01' height='01'/><rect class='w10' x='36' y='41' width='02' height='01'/><rect class='w10' x='30' y='42' width='06' height='01'/><rect class='w10' x='28' y='41' width='02' height='01'/><rect class='w10' x='27' y='40' width='01' height='01'/><rect class='w10' x='25' y='39' width='02' height='01'/><rect class='w10' x='24' y='38' width='01' height='01'/><rect class='w10' x='23' y='37' width='01' height='01'/><rect class='w10' x='22' y='36' width='01' height='01'/><rect class='w10' x='21' y='35' width='01' height='01'/><rect class='w10' x='20' y='34' width='01' height='01'/><rect class='w10' x='19' y='31' width='01' height='03'/><rect class='w10' x='18' y='28' width='01' height='03'/><rect class='w10' x='33' y='43' width='01' height='01'/><rect class='w10' x='34' y='44' width='01' height='01'/><rect class='w10' x='35' y='45' width='08' height='01'/><rect class='w10' x='43' y='46' width='03' height='01'/><rect class='w10' x='46' y='47' width='01' height='01'/><rect class='w10' x='47' y='48' width='02' height='01'/><rect class='w10' x='49' y='49' width='01' height='01'/><rect class='w10' x='18' y='36' width='01' height='01'/><rect class='w10' x='19' y='37' width='01' height='02'/><rect class='w10' x='14' y='45' width='02' height='01'/><rect class='w10' x='16' y='44' width='01' height='01'/><rect class='w10' x='17' y='43' width='02' height='01'/><rect class='w10' x='23' y='47' width='02' height='01'/><rect class='w10' x='25' y='48' width='04' height='01'/><rect class='w10' x='29' y='47' width='02' height='01'/>";

    uint256 private constant _traitCount = 9;

    uint256 private constant _hashLength = 30;

    Attribute[][] private _attributes;
    mapping(uint256 => bool) private _mintedTokens;     //Hash => Is minted
    mapping(uint256 => uint256) private _tokenHashes;   //Id => Hash

    uint256 private _totalSupply;

    bool private _supplyLocked;

    uint256 private _mintCost;
    uint256 private _mintsLeft;

    uint256 private _currentSeries;
    uint256[] _seriesRanges;

    /* Hashing standard (hash reads left to right)

        Background  0
        Character   1
        Beard       2
        Forehead    3
        Mouth       4   
        Eyes        5
        Nose        6
        Hat         7
        Accessory   8
        Phunk       9
    */

    constructor() ERC721("Wojek", "WOJEK")
    {
        //Initialize the _attributes array
        for(uint256 i = 0; i < _traitCount; i++)
        {
            _attributes.push();
        }
    }

    receive() external payable
    {
        mint();
    }

    function withdraw() public onlyOwner
    {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }

    function totalSupply() public view returns (uint256)
    {
        return _totalSupply;
    }

    function isSupplyLocked() public view returns (bool)
    {
        return _supplyLocked;
    }
    
    function lockSupply() public onlyOwner returns (bool)
    {
        _supplyLocked = true;

        return true;
    }

    function finishSeries() public onlyOwner returns (bool)
    {
        _seriesRanges.push(_totalSupply);

        _currentSeries++;

        return true;
    }

    function mintsLeft() public view returns (uint256)
    {
        return _mintsLeft;
    }

    function mintCost() public view returns (uint256)
    {
        return _mintCost;
    }

    function startMint(uint256 amount, uint256 cost) public onlyOwner returns (bool)
    {
        require(_supplyLocked == false);

        _mintCost = cost;
        _mintsLeft = amount;

        return true;
    }

    function endMint() public onlyOwner returns (bool)
    {
        require(_mintsLeft > 0);
        _mintsLeft = 0;

        return true;
    }

    function mint() public payable returns (bool)
    {
        require(_supplyLocked == false);
        require(_mintsLeft > 0);
        require(msg.value >= _mintCost);

        uint256 supply = _totalSupply;

        address sender = _msgSender();

        uint256 randomNumber = WojekHelper.dirtyRandom(supply * gasleft(), sender);

        uint256 hash = 10 ** _hashLength;

        for(uint256 i = 0; i < _traitCount; i++)
        {
            hash += (10 ** (_hashLength - (i * 3) - 3)) * (randomNumber % _attributes[i].length);

            randomNumber >>= 8;
        }

        if(randomNumber % 100 < 5)
        {
            hash += 1; 
        }

        require(_mintedTokens[hash] == false);

        _mintedTokens[hash] = true;
        _tokenHashes[supply] = hash;

        _safeMint(sender, supply);

        _mintsLeft--;
        _totalSupply++;

        emit Transfer(address(0), sender, supply);

        return true;
    }

    function mintHashes(uint256[] memory hashes) public onlyOwner returns (bool)
    {
        require(_supplyLocked == false);

        address sender = _msgSender();

        uint256 supply = _totalSupply;

        uint256 mintedCount;

        for(uint256 i = 0; i < hashes.length; i++)
        {
            _mintedTokens[hashes[i]] = true;
            _tokenHashes[supply + mintedCount] = hashes[i];

            _safeMint(sender, supply + mintedCount);
            mintedCount++;
        }

        _totalSupply += mintedCount;

        return true;
    }

    function addAttributes(uint256 attributeType, Attribute[] memory newAttributes) public onlyOwner returns(bool)
    {
        for(uint256 i = 0; i < newAttributes.length; i++)
        {
            _attributes[attributeType].push(Attribute
            (
                newAttributes[i].trait,
                newAttributes[i].value,
                newAttributes[i].rectCount,
                newAttributes[i].svg
            ));
        }

        return true;
    }

    function tokenURI(uint256 id) public view override returns (string memory)
    {
        require(_exists(id));

        uint256 hash = _tokenHashes[id];

        require(_mintedTokens[hash] == true);

        string memory uri = string(abi.encodePacked
        (
            "data:application/json;base64,",
            WojekHelper.encode
            (
                bytes(string(abi.encodePacked
                (
                    '{"name": "Wojek #',
                    WojekHelper.toString(id),
                    '","description": "',
                    "Wojek's display a wide variety of emotions, even the feelsbad ones.", 
                    '","image": "data:image/svg+xml;base64,',
                    WojekHelper.encode(_generateSvg(hash)),
                    '","attributes":',
                    _hashMetadata(hash, id),
                    "}"
                )))
            )
        ));

        return uri;
    }

    function _generateSvg(uint256 hash) private view returns(bytes memory) 
    {
        bytes memory xScale = "1";

        if(WojekHelper.splitHash(hash, _hashLength, 9) > 0)
        {
            //Phunked
            xScale = "-1";
        }

        bytes memory svg = abi.encodePacked(
            _svgHeader, xScale, ",1)'>", _svgStyles, 
            _attributes[0][WojekHelper.splitHash(hash, _hashLength, 0)].trait, 
            _attributes[1][WojekHelper.splitHash(hash, _hashLength, 1)].trait, 
            "</style>"
        );

        //Background
        svg = abi.encodePacked(svg, _background);

        //Fill
        svg = abi.encodePacked(svg, _wojakFill);

        //Outline
        svg = abi.encodePacked(svg, _wojakOutline);

        for(uint256 i = 2; i < _traitCount; i++) 
        {
            uint256 attributeIndex = WojekHelper.splitHash(hash, _hashLength, i);

            for(uint256 a = 0; a < _attributes[i][attributeIndex].rectCount; a++)
            {
                svg = abi.encodePacked(svg, 
                    "<rect class='w", WojekHelper.toString(WojekHelper.splitSVG(_attributes[i][attributeIndex].svg[a], 0)), 
                    "' x='", WojekHelper.toString(WojekHelper.splitSVG(_attributes[i][attributeIndex].svg[a], 1)), 
                    "' y='", WojekHelper.toString(WojekHelper.splitSVG(_attributes[i][attributeIndex].svg[a], 2)), 
                    "' width='", WojekHelper.toString(WojekHelper.splitSVG(_attributes[i][attributeIndex].svg[a], 3)), 
                    "' height='", WojekHelper.toString(WojekHelper.splitSVG(_attributes[i][attributeIndex].svg[a], 4)), 
                    "'/>"
                );
            }
        }

        return abi.encodePacked(svg, "</svg>");
    }

    function _hashMetadata(uint256 hash, uint256 id) private view returns(string memory)
    {
        string memory metadata;

        for(uint256 i = 0; i < _traitCount; i++) 
        {
            uint256 attributeIndex = WojekHelper.splitHash(hash, _hashLength, i);

            if(_attributes[i][attributeIndex].rectCount > 0)
            {
                metadata = string(abi.encodePacked
                (
                    metadata,
                    '{"trait_type":"',
                    _attributes[i][attributeIndex].trait,
                    '","value":"',
                    _attributes[i][attributeIndex].value,
                    '"}'
                ));
            }
        }

        if(WojekHelper.splitHash(hash, _hashLength, 9) > 0)
        {
            //Phunked
            metadata = string(abi.encodePacked
            (
                metadata,
                '{"trait_type":"',
                "Phunk",
                '","value":"',
                "Phunked",
                '"}'
            ));
        }

        for(uint256 i = 0; i < _seriesRanges.length; i++) 
        {
            if(id < _seriesRanges[i])
            {
                //Series
                metadata = string(abi.encodePacked
                (
                    metadata,
                    '{"trait_type":"',
                    "Series",
                    '","value":"',
                    WojekHelper.toString(i),
                    '"}'
                ));
            }
        }

        return string(abi.encodePacked("[", metadata, "]"));
    }
}